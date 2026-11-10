// The Isar implementation of eventador's EventStore and EventStream.

import 'dart:async';
import 'dart:io';

import 'package:eventador/eventador.dart';
import 'package:eventador/store_support.dart';
import 'package:isar_community/isar.dart';
import 'package:logging/logging.dart';

import 'event_envelope.dart';
import 'projection_checkpoint.dart';
import 'snapshot_envelope.dart';

final Logger _log = Logger('eventador.EventStore');

/// Isar-based implementation of EventStore with EventStream support
/// Implements Akka Persistence-style streaming queries
class IsarEventStore
    implements EventStore, PurgeableEventStore, EventStream {
  final Isar _isar;
  final StreamController<JournalEntry> _live =
      StreamController<JournalEntry>.broadcast();

  /// Expose the underlying Isar instance for shared use (e.g., read model storage).
  Isar get isar => _isar;

  /// Required Isar schemas for the event store
  /// Use this when creating an external Isar instance to pass to the constructor
  static const List<CollectionSchema<dynamic>> requiredSchemas = [
    EventEnvelopeSchema,
    SnapshotEnvelopeSchema,
  ];

  /// Required Isar schemas for projections
  /// Include these when using ProjectionActor with
  /// checkpoint persistence
  static const List<CollectionSchema<dynamic>> projectionSchemas = [
    ProjectionCheckpointSchema,
  ];

  /// All required schemas (event store + projections)
  /// Use this when you want both event sourcing and projections
  static const List<CollectionSchema<dynamic>> allSchemas = [
    ...requiredSchemas,
    ...projectionSchemas,
  ];

  /// Constructor that accepts an external Isar instance
  /// The Isar instance must be opened with the schemas from [requiredSchemas]
  /// (or [allSchemas] when projections checkpoint into the same database).
  IsarEventStore(this._isar);

  /// Factory constructor to create and initialize Isar database.
  ///
  /// Creates an internal Isar instance with [allSchemas], so the returned
  /// store's [isar] can also back projection checkpoints.
  ///
  /// [downloadIsarCore] controls whether the Isar native library may be
  /// fetched from the network if it is not bundled. Keep it `false` in
  /// production builds and ship the library with the application.
  static Future<IsarEventStore> create({
    required String directory,
    String name = 'eventador',
    bool downloadIsarCore = true,
  }) async {
    // Ensure directory exists
    final dir = Directory(directory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    await Isar.initializeIsarCore(download: downloadIsarCore);

    // Initialize Isar with required schemas
    final isar = await Isar.open(
      allSchemas,
      directory: directory,
      name: name,
    );

    return IsarEventStore(isar);
  }

  EventEnvelope _envelopeFor(
      String persistenceId, Event event, int sequenceNumber) {
    return EventEnvelope()
      ..persistenceId = persistenceId
      ..sequenceNumber = sequenceNumber
      ..setPayload(CborSerializer.serializeEvent(event),
          CborSerializer.serializeMetadata(event.persistableMetadata))
      ..eventType = event.typeName
      ..timestamp = event.timestamp
      ..eventId = event.eventId
      ..schemaVersion = event is VersionedEvent ? event.schemaVersion : 1;
  }

  void _publish(JournalEntry persisted) {
    if (!_live.isClosed) {
      _live.add(persisted);
    }
  }

  /// The largest event, with its metadata, an envelope is written with.
  ///
  /// Isar stores an object of 16 MiB without an error but leaves it out of
  /// its indexes, so the journal's head is not found and the next write
  /// fails its version check (and above 16 MiB its errors name the wrong
  /// cause). Kept below that, with room for the envelope's other fields.
  static const int maxPayloadBytes = journalMaxPayloadBytes;

  static void _checkSize(EventEnvelope envelope) {
    final size = envelope.payload.length + envelope.metadataPayload.length;
    if (size > maxPayloadBytes) {
      throw EventTooLargeException(envelope.eventType, size, maxPayloadBytes);
    }
  }

  /// Fails the write transaction, so nothing of it is kept, unless the
  /// journal's head, read through the index the version check uses, is
  /// [sequenceNumber]: a write the index did not take is not reported as
  /// done.
  Future<void> _checkHead(String persistenceId, int sequenceNumber) async {
    final head = await getHighestSequenceNumber(persistenceId);
    if (head != sequenceNumber) {
      throw EventStoreException('Event $sequenceNumber of $persistenceId was written but is not in '
          'the journal index (head is $head); the write is undone');
    }
  }

  @override
  Future<void> persistEvent(
      String persistenceId, Event event, int expectedVersion) async {
    final nextSequence = expectedVersion + 1;
    final envelopeId = await _isar.writeTxn(() async {
      // Check optimistic concurrency control
      final currentVersion = await getHighestSequenceNumber(persistenceId);
      if (currentVersion != expectedVersion) {
        throw ConcurrencyException(
            'Expected version $expectedVersion, but current version is $currentVersion');
      }

      final envelope = _envelopeFor(persistenceId, event, nextSequence);
      _checkSize(envelope);
      final id = await _isar.eventEnvelopes.put(envelope);
      await _checkHead(persistenceId, nextSequence);
      return id;
    });

    // IMPORTANT: Emit event to stream AFTER transaction commits
    // This ensures subscribers can query the envelope from Isar
    _publish(JournalEntry(event, envelopeId, persistenceId, nextSequence));
  }

  @override
  Future<void> persistEvents(
      String persistenceId, List<Event> events, int expectedVersion) async {
    if (events.isEmpty) return;

    final envelopeIds = await _isar.writeTxn(() async {
      // Check optimistic concurrency control
      final currentVersion = await getHighestSequenceNumber(persistenceId);
      if (currentVersion != expectedVersion) {
        throw ConcurrencyException(
            'Expected version $expectedVersion, but current version is $currentVersion');
      }

      final envelopes = <EventEnvelope>[
        for (var i = 0; i < events.length; i++)
          _envelopeFor(persistenceId, events[i], currentVersion + i + 1),
      ];

      envelopes.forEach(_checkSize);

      // Store all envelopes atomically
      final ids = await _isar.eventEnvelopes.putAll(envelopes);
      await _checkHead(persistenceId, currentVersion + events.length);
      return ids;
    });

    // IMPORTANT: Emit events to stream AFTER transaction commits
    for (var i = 0; i < events.length; i++) {
      _publish(JournalEntry(
          events[i], envelopeIds[i], persistenceId, expectedVersion + i + 1));
    }
  }

  @override
  Future<List<Event>> getEvents(String persistenceId,
      {int fromSequence = 0, int? toSequence}) async {
    try {
      // The composite (persistenceId, sequenceNumber) index returns the
      // requested range already in sequence order.
      final query = _isar.eventEnvelopes.where();
      final envelopes = toSequence == null
          ? await query
              .persistenceIdEqualToSequenceNumberGreaterThan(
                  persistenceId, fromSequence)
              .findAll()
          : await query
              .persistenceIdEqualToSequenceNumberBetween(
                  persistenceId, fromSequence, toSequence,
                  includeLower: false)
              .findAll();

      final events = <Event>[];
      for (final envelope in envelopes) {
        try {
          events.add(CborSerializer.deserializeEvent(
            envelope.payload,
            envelope.eventType,
          ));
        } catch (e) {
          throw EventStoreException(
            'Failed to deserialize event ${envelope.eventId} of type ${envelope.eventType}',
            e,
          );
        }
      }

      return events;
    } catch (e) {
      if (e is EventStoreException) rethrow;
      throw EventStoreException('Failed to get events for $persistenceId', e);
    }
  }

  @override
  Future<int> getHighestSequenceNumber(String persistenceId) async {
    try {
      final envelope = await _isar.eventEnvelopes
          .where(sort: Sort.desc)
          .persistenceIdEqualToAnySequenceNumber(persistenceId)
          .findFirst();

      return envelope?.sequenceNumber ?? 0;
    } catch (e) {
      throw EventStoreException(
          'Failed to get highest sequence number for $persistenceId', e);
    }
  }

  @override
  Future<void> saveSnapshot(
      String persistenceId, dynamic state, int sequenceNumber) async {
    try {
      await _isar.writeTxn(() async {
        // Serialize state and metadata
        final snapshotData = CborSerializer.serializeState(state);
        final metadataData =
            CborSerializer.serializeMetadata(<String, dynamic>{});
        if (snapshotData.length > maxPayloadBytes) {
          throw EventStoreException('Snapshot of $persistenceId is ${snapshotData.length} bytes '
              'encoded; at most $maxPayloadBytes are stored');
        }

        // Create snapshot envelope
        final envelope = SnapshotEnvelope()
          ..persistenceId = persistenceId
          ..sequenceNumber = sequenceNumber
          ..setPayload(snapshotData, metadataData)
          ..timestamp = DateTime.now()
          ..stateType = snapshotStateTypeName(state)
          ..schemaVersion = 1
          ..sizeBytes = snapshotData.length;

        // Replace existing snapshot (upsert by unique persistenceId)
        await _isar.snapshotEnvelopes.putByPersistenceId(envelope);
      });
    } catch (e) {
      throw EventStoreException(
          'Failed to save snapshot for $persistenceId', e);
    }
  }

  @override
  Future<SnapshotData?> loadSnapshot(String persistenceId) async {
    try {
      final envelope = await _isar.snapshotEnvelopes
          .where()
          .persistenceIdEqualTo(persistenceId)
          .findFirst();

      if (envelope == null) {
        return null;
      }

      // Deserialize state
      final state = CborSerializer.deserializeState(
        envelope.payload,
        envelope.stateType,
      );

      return SnapshotData(
        state: state,
        sequenceNumber: envelope.sequenceNumber,
        timestamp: envelope.timestamp,
      );
    } catch (e) {
      throw EventStoreException(
          'Failed to load snapshot for $persistenceId', e);
    }
  }

  @override
  Future<void> deleteOldSnapshots(String persistenceId, int keepCount) async {
    try {
      await _isar.writeTxn(() async {
        // Only one snapshot is kept per persistence ID (unique index), so
        // there is nothing to trim for keepCount > 0.
        if (keepCount <= 0) {
          // Delete all snapshots for this persistence ID
          await _isar.snapshotEnvelopes
              .where()
              .persistenceIdEqualTo(persistenceId)
              .deleteAll();
        }
      });
    } catch (e) {
      throw EventStoreException(
          'Failed to delete old snapshots for $persistenceId', e);
    }
  }

  @override
  Future<int> deleteEvents(String persistenceId) async {
    try {
      return await _isar.writeTxn(() async {
        // Sequence numbers start at 1, so "greater than 0" is all of them.
        final removed = await _isar.eventEnvelopes
            .where()
            .persistenceIdEqualToSequenceNumberGreaterThan(persistenceId, 0)
            .deleteAll();
        await _isar.snapshotEnvelopes
            .where()
            .persistenceIdEqualTo(persistenceId)
            .deleteAll();
        return removed;
      });
    } catch (e) {
      throw EventStoreException(
          'Failed to delete events for $persistenceId', e);
    }
  }

  @override
  Future<void> close() async {
    await _live.close();
    if (_isar.isOpen) {
      await _isar.close();
    }
  }

  // ============================================================================
  // EventStream Implementation (Akka Persistence Query equivalent)
  // ============================================================================

  /// Page size for paginated event queries to avoid loading all events into memory
  static const int _pageSize = 500;

  JournalEntry? _decode(EventEnvelope envelope) {
    try {
      final event = CborSerializer.deserializeEvent(
        envelope.payload,
        envelope.eventType,
      );
      return JournalEntry(
          event, envelope.id, envelope.persistenceId, envelope.sequenceNumber);
    } catch (e) {
      _log.warning('Error deserializing event ${envelope.eventId}: $e');
      return null;
    }
  }

  /// Journal entries with envelope id greater than [fromId], in id order,
  /// read in pages by key so the cost does not grow with the offset.
  Stream<JournalEntry> _journalAfterId(int fromId) async* {
    var lastId = fromId;
    while (true) {
      final page = await _isar.eventEnvelopes
          .where()
          .idGreaterThan(lastId)
          .limit(_pageSize)
          .findAll();
      if (page.isEmpty) break;

      for (final envelope in page) {
        final decoded = _decode(envelope);
        if (decoded != null) yield decoded;
      }

      lastId = page.last.id;
      if (page.length < _pageSize) break;
    }
  }

  /// One actor's journal entries with sequence number greater than
  /// [fromSequence], in sequence order, read in pages by key.
  Stream<JournalEntry> _journalForActorAfter(
      String persistenceId, int fromSequence) async* {
    var lastSequence = fromSequence;
    while (true) {
      final page = await _isar.eventEnvelopes
          .where()
          .persistenceIdEqualToSequenceNumberGreaterThan(
              persistenceId, lastSequence)
          .limit(_pageSize)
          .findAll();
      if (page.isEmpty) break;

      for (final envelope in page) {
        final decoded = _decode(envelope);
        if (decoded != null) yield decoded;
      }

      lastSequence = page.last.sequenceNumber;
      if (page.length < _pageSize) break;
    }
  }

  @override
  Stream<Event> allEvents({
    int fromSequence = 0,
    bool live = true,
  }) {
    return allEventsWithSequence(fromSequence: fromSequence, live: live)
        .map((record) => record.$1);
  }

  @override
  Stream<(Event, int)> allEventsWithSequence({
    int fromSequence = 0,
    bool live = true,
  }) {
    final historical = _journalAfterId(fromSequence);
    final source = live
        ? replayThenLive(
            from: fromSequence,
            historical: historical,
            live: _live.stream,
            keyOf: (p) => p.position,
          )
        : historical;
    return source.map((p) => (p.event, p.position));
  }

  @override
  Stream<Event> eventsByTag(
    String tag, {
    int fromSequence = 0,
    bool live = true,
  }) {
    return allEvents(fromSequence: fromSequence, live: live)
        .where((event) => event is EventTags && event.tags.contains(tag));
  }

  @override
  Stream<Event> eventsByPersistenceId(
    String persistenceId, {
    int fromSequence = 0,
    bool live = true,
  }) {
    final historical = _journalForActorAfter(persistenceId, fromSequence);
    final source = live
        ? replayThenLive(
            from: fromSequence,
            historical: historical,
            live: _live.stream,
            keyOf: (p) => p.sequenceNumber,
            accept: (p) => p.persistenceId == persistenceId,
          )
        : historical;
    return source.map((p) => p.event);
  }

  @override
  Stream<String> currentPersistenceIds() async* {
    // Get all unique persistence IDs
    final persistenceIds = await _isar.eventEnvelopes
        .where()
        .distinctByPersistenceId()
        .persistenceIdProperty()
        .findAll();

    yield* Stream.fromIterable(persistenceIds);
  }
}
