/// Regression test: a projection must see every event, including events
/// persisted while it is still replaying history, and must apply them in
/// journal order even when `handle()` is slow.
///
/// Originally written against `ProjectionManager`; now drives
/// `ProjectionActor`, the projection runtime.
library;

import 'dart:io';

import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

/// Test projection with slow, asynchronous processing.
class SlowTrackingProjection extends Projection<SlowTrackingReadModel> {
  final String _projectionId;
  final Duration _processingDelay;
  SlowTrackingReadModel _readModel = SlowTrackingReadModel.empty();

  /// How many `handle()` calls are in flight at once; must never exceed 1.
  int inFlight = 0;
  int maxInFlight = 0;

  SlowTrackingProjection(this._projectionId, {Duration? processingDelay})
      : _processingDelay = processingDelay ?? const Duration(milliseconds: 20);

  @override
  String get projectionId => _projectionId;

  @override
  SlowTrackingReadModel get readModel => _readModel;

  @override
  List<Type> get interestedEventTypes => [ConcurrentTestEvent];

  @override
  Future<bool> handle(Event event) async {
    if (event is ConcurrentTestEvent) {
      inFlight++;
      if (inFlight > maxInFlight) maxInFlight = inFlight;
      // Simulate slow processing (like database writes during import)
      await Future.delayed(_processingDelay);
      _readModel =
          _readModel.addProcessedEvent(event.eventId, event.sequenceNumber);
      inFlight--;
      return true;
    }
    return false;
  }

  @override
  Future<void> rebuild() async {
    await reset();
  }

  @override
  Future<void> reset() async {
    _readModel = SlowTrackingReadModel.empty();
  }

  @override
  Future<int> getCheckpoint() async => 0;

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {}
}

/// Read model that tracks which events have been processed
class SlowTrackingReadModel {
  final List<String> processedEventIds;
  final List<int> processedSequenceNumbers;
  final int eventCount;

  const SlowTrackingReadModel({
    required this.processedEventIds,
    required this.processedSequenceNumbers,
    required this.eventCount,
  });

  factory SlowTrackingReadModel.empty() => const SlowTrackingReadModel(
        processedEventIds: [],
        processedSequenceNumbers: [],
        eventCount: 0,
      );

  SlowTrackingReadModel addProcessedEvent(String eventId, int sequenceNumber) {
    return SlowTrackingReadModel(
      processedEventIds: [...processedEventIds, eventId],
      processedSequenceNumbers: [...processedSequenceNumbers, sequenceNumber],
      eventCount: eventCount + 1,
    );
  }
}

/// Test event with sequence number tracking
class ConcurrentTestEvent extends Event {
  final int sequenceNumber;
  final String data;

  ConcurrentTestEvent(this.sequenceNumber, this.data) : super();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['sequenceNumber'] = sequenceNumber;
    map['data'] = data;
    return map;
  }

  static ConcurrentTestEvent fromMap(Map<String, dynamic> map) {
    return ConcurrentTestEvent(
      map['sequenceNumber'] as int,
      map['data'] as String,
    );
  }
}

Future<void> waitFor(bool Function() condition,
    {Duration timeout = const Duration(seconds: 15), String? reason}) async {
  final stopwatch = Stopwatch()..start();
  while (!condition()) {
    if (stopwatch.elapsed > timeout) {
      fail('Timed out waiting for ${reason ?? 'condition'}');
    }
    await Future.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  group('Projection sees events persisted during its replay', () {
    late Directory tempDir;
    late Isar isar;
    late IsarEventStore eventStore;
    late ActorSystem system;

    setUp(() async {
      EventRegistry.register<ConcurrentTestEvent>(
        'ConcurrentTestEvent',
        (map) => ConcurrentTestEvent.fromMap(map),
      );

      tempDir =
          await Directory.systemTemp.createTemp('eventador_concurrent_test_');

      await initIsarCoreForTests();
      isar = await Isar.open(
        IsarEventStore.allSchemas,
        directory: tempDir.path,
        name: 'test_concurrent_events',
      );

      eventStore = IsarEventStore(isar);
      system = LocalActorSystem();
    });

    tearDown(() async {
      await system.shutdown();
      await isar.close();
      await tempDir.delete(recursive: true);
      EventRegistry.clear();
    });

    test('no gaps, in order, one handle() at a time under concurrent writes',
        () async {
      const projectionId = 'slow-tracking-projection';
      const aggregateId = 'test-aggregate';
      const totalEvents = 30;

      // Ten historical events, replayed slowly once the projection starts.
      for (int i = 1; i <= 10; i++) {
        await eventStore.persistEvent(
            '$aggregateId-$i', ConcurrentTestEvent(i, 'event-$i'), 0);
      }

      final projection = SlowTrackingProjection(
        projectionId,
        processingDelay: const Duration(milliseconds: 30),
      );
      final ref = await system.spawn(
        'projection-$projectionId',
        () => ProjectionActor(projection, eventStore, checkpoints: IsarProjectionCheckpointStore(isar)),
      );

      // While the projection is still busy with history, persist 20 more.
      await Future.delayed(const Duration(milliseconds: 50));
      for (int i = 11; i <= totalEvents; i++) {
        await eventStore.persistEvent(
            '$aggregateId-$i', ConcurrentTestEvent(i, 'event-$i'), 0);
        await Future.delayed(const Duration(milliseconds: 5));
      }
      expect(await isar.eventEnvelopes.count(), totalEvents);

      await waitFor(() => projection.readModel.eventCount == totalEvents,
          reason: 'all $totalEvents events to be applied '
              '(got ${projection.readModel.processedSequenceNumbers})');

      final processed = projection.readModel.processedSequenceNumbers;
      expect(processed, List.generate(totalEvents, (i) => i + 1),
          reason: 'events must arrive exactly once and in journal order');
      expect(projection.maxInFlight, 1,
          reason: 'handle() calls must never overlap');

      await ref.ask<StoppedAck>(StopProjection());
    });

    test('sequential persistence before start is replayed completely',
        () async {
      const projectionId = 'sequential-projection';
      const aggregateId = 'sequential-aggregate';

      for (int i = 1; i <= 10; i++) {
        await eventStore.persistEvent(
            '$aggregateId-$i', ConcurrentTestEvent(i, 'event-$i'), 0);
      }

      final projection = SlowTrackingProjection(projectionId);
      final ref = await system.spawn(
        'projection-$projectionId',
        () => ProjectionActor(projection, eventStore, checkpoints: IsarProjectionCheckpointStore(isar)),
      );

      await waitFor(() => projection.readModel.eventCount == 10,
          reason: 'replay of 10 events');
      expect(projection.readModel.processedSequenceNumbers,
          List.generate(10, (i) => i + 1));

      await ref.ask<StoppedAck>(StopProjection());
    });
  });
}
