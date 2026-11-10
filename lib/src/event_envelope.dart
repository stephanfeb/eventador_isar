// Isar event storage schema - Phase 1 Week 3 placeholder
// Event envelope for storing events in Isar database

import 'dart:convert';
import 'package:isar_community/isar.dart';

part 'event_envelope.g.dart';

/// Isar collection for storing events
/// This wraps the actual event data with metadata needed for storage and retrieval
@collection
class EventEnvelope {
  /// Auto-incrementing ID for Isar
  Id id = Isar.autoIncrement;

  /// Persistence ID of the actor that generated this event.
  ///
  /// Indexed together with [sequenceNumber] so that an actor's journal can be
  /// read in order, from any position, and its head found, without loading or
  /// sorting the whole journal.
  @Index(composite: [CompositeIndex('sequenceNumber')])
  late String persistenceId;

  /// Sequence number within the persistence ID
  /// Used for ordering events and optimistic concurrency
  late int sequenceNumber;

  /// CBOR-encoded event data, as written before 4.2.0: a list of 64-bit
  /// integers, eight bytes stored for each byte of the event. Empty for an
  /// event written since; read [payload], which holds either.
  late List<int> eventData;

  /// CBOR-encoded event data, one byte stored for each byte (since 4.2.0).
  /// Null for an event written before.
  List<byte>? eventBytes;

  /// Type of the event (class name)
  /// Used for deserialization and event routing
  late String eventType;

  /// Timestamp when the event was persisted
  late DateTime timestamp;

  /// Additional metadata as key-value pairs (serialized as CBOR)
  /// Includes correlation IDs, causation IDs, user context, etc.
  /// As written before 4.2.0; empty since. Read [metadataPayload].
  late List<int> metadataData;

  /// The metadata, one byte stored for each byte (since 4.2.0).
  List<byte>? metadataBytes;

  /// Event ID for deduplication
  /// Indexed for fast lookup
  @Index(unique: true)
  late String eventId;

  /// Schema version of the event
  /// Used for event migration and backward compatibility
  late int schemaVersion;

  EventEnvelope();

  /// The CBOR-encoded event, wherever this envelope holds it.
  @ignore
  List<int> get payload => eventBytes ?? eventData;

  /// The CBOR-encoded metadata, wherever this envelope holds it.
  @ignore
  List<int> get metadataPayload => metadataBytes ?? metadataData;

  /// Sets [payload] and [metadataPayload], in the byte fields.
  void setPayload(List<int> event, List<int> metadata) {
    eventBytes = event;
    metadataBytes = metadata;
    eventData = const [];
    metadataData = const [];
  }

  // TODO: Implement in Phase 1 Week 3
  // - CBOR serialization/deserialization
  // - Event type registry for deserialization
  // - Metadata handling and indexing
  // - Performance optimizations

  /// Serialize to JSON for backup
  Map<String, dynamic> toJson() {
    return {
      'persistenceId': persistenceId,
      'sequenceNumber': sequenceNumber,
      'eventData': base64Encode(payload),
      'eventType': eventType,
      'timestamp': timestamp.toIso8601String(),
      'metadataData': base64Encode(metadataPayload),
      'eventId': eventId,
      'schemaVersion': schemaVersion,
    };
  }

  /// Deserialize from JSON for restore
  factory EventEnvelope.fromJson(Map<String, dynamic> json) {
    return EventEnvelope()
      ..persistenceId = json['persistenceId'] as String
      ..sequenceNumber = json['sequenceNumber'] as int
      ..setPayload(base64Decode(json['eventData'] as String), base64Decode(json['metadataData'] as String))
      ..eventType = json['eventType'] as String
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..eventId = json['eventId'] as String
      ..schemaVersion = json['schemaVersion'] as int;
  }
}
