/// Regression test: a projection must not replay already-checkpointed events
/// after a restart, and must pick up only new events afterwards.
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

/// Test projection that tracks ALL events it processes
class TrackingProjection extends Projection<TrackingReadModel> {
  final String _projectionId;
  TrackingReadModel _readModel = TrackingReadModel.empty();

  TrackingProjection(this._projectionId);

  @override
  String get projectionId => _projectionId;

  @override
  TrackingReadModel get readModel => _readModel;

  @override
  List<Type> get interestedEventTypes => [TrackingEvent];

  @override
  Future<bool> handle(Event event) async {
    if (event is TrackingEvent) {
      _readModel = _readModel.addProcessedEvent(event.eventId);
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
    _readModel = TrackingReadModel.empty();
  }

  @override
  Future<int> getCheckpoint() async => 0; // the actor persists checkpoints

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {}
}

/// Read model that tracks which events have been processed
class TrackingReadModel {
  final List<String> processedEventIds;
  final int eventCount;

  const TrackingReadModel({
    required this.processedEventIds,
    required this.eventCount,
  });

  factory TrackingReadModel.empty() => const TrackingReadModel(
        processedEventIds: [],
        eventCount: 0,
      );

  TrackingReadModel addProcessedEvent(String eventId) {
    return TrackingReadModel(
      processedEventIds: [...processedEventIds, eventId],
      eventCount: eventCount + 1,
    );
  }
}

/// Test event
class TrackingEvent extends Event {
  final String data;

  TrackingEvent(this.data) : super();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['data'] = data;
    return map;
  }

  static TrackingEvent fromMap(Map<String, dynamic> map) {
    return TrackingEvent(map['data'] as String);
  }
}

Future<void> waitFor(bool Function() condition,
    {Duration timeout = const Duration(seconds: 10), String? reason}) async {
  final stopwatch = Stopwatch()..start();
  while (!condition()) {
    if (stopwatch.elapsed > timeout) {
      fail('Timed out waiting for ${reason ?? 'condition'}');
    }
    await Future.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  group('Projection restart - checkpointed events are not replayed', () {
    late Directory tempDir;
    late Isar isar;
    late IsarEventStore eventStore;
    late ActorSystem system;

    setUp(() async {
      EventRegistry.register<TrackingEvent>(
        'TrackingEvent',
        (map) => TrackingEvent.fromMap(map),
      );

      tempDir =
          await Directory.systemTemp.createTemp('eventador_restart_bug_test_');

      await initIsarCoreForTests();
      isar = await Isar.open(
        IsarEventStore.allSchemas,
        directory: tempDir.path,
        name: 'test_restart_bug',
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

    Future<ActorRef> spawnProjection(TrackingProjection projection) {
      return system.spawn(
        'projection-${projection.projectionId}',
        () => ProjectionActor(projection, eventStore, checkpoints: IsarProjectionCheckpointStore(isar)),
      );
    }

    Future<ProjectionCheckpoint?> readCheckpoint(String projectionId) {
      return isar.projectionCheckpoints
          .where()
          .projectionIdEqualTo(projectionId)
          .findFirst();
    }

    test('restarted projection processes only new events', () async {
      const projectionId = 'tracking-projection';
      const aggregateId = 'test-aggregate';

      // PHASE 1: five historical events, replayed on first start.
      for (int i = 0; i < 5; i++) {
        await eventStore.persistEvent(
            '$aggregateId-$i', TrackingEvent('event-$i'), 0);
      }

      final projection1 = TrackingProjection(projectionId);
      final ref1 = await spawnProjection(projection1);
      await waitFor(() => projection1.readModel.eventCount == 5,
          reason: 'initial replay of 5 events');

      // Checkpoints are batched; the flush on stop makes the position durable.
      await ref1.ask<StoppedAck>(StopProjection());
      final checkpoint1 = await readCheckpoint(projectionId);
      expect(checkpoint1, isNotNull, reason: 'Checkpoint should be saved');
      expect(checkpoint1!.lastProcessedSequence, greaterThan(0));
      expect(checkpoint1.eventsProcessed, 5);

      // PHASE 2: restart. Nothing new has happened, so nothing is replayed.
      final projection2 = TrackingProjection(projectionId);
      final ref2 = await spawnProjection(projection2);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(projection2.readModel.eventCount, 0,
          reason: 'All 5 events were checkpointed before the restart; '
              'replayed: ${projection2.readModel.processedEventIds}');
      await ref2.ask<StoppedAck>(StopProjection());
      final checkpoint2 = await readCheckpoint(projectionId);
      expect(checkpoint2!.lastProcessedSequence,
          checkpoint1.lastProcessedSequence);

      // PHASE 3: restart again, then persist three new events live.
      final projection3 = TrackingProjection(projectionId);
      final ref3 = await spawnProjection(projection3);
      for (int i = 5; i < 8; i++) {
        await eventStore.persistEvent(
            '$aggregateId-$i', TrackingEvent('event-$i'), 0);
      }
      await waitFor(() => projection3.readModel.eventCount == 3,
          reason: 'the 3 new events to be applied');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(projection3.readModel.eventCount, 3,
          reason: 'Must not replay the 5 old events');

      await ref3.ask<StoppedAck>(StopProjection());
      final checkpoint3 = await readCheckpoint(projectionId);
      expect(checkpoint3!.lastProcessedSequence,
          greaterThan(checkpoint2.lastProcessedSequence));
      expect(await isar.eventEnvelopes.count(), 8);
    });
  });
}
