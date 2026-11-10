import 'dart:io';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

/// Test projection that uses persistent checkpoints
class TestProjection extends Projection<TestReadModel> {
  final Isar _isar;
  final String _projectionId;
  TestReadModel _readModel = TestReadModel.empty();
  int _eventsHandled = 0;

  TestProjection(this._isar, this._projectionId);

  @override
  String get projectionId => _projectionId;

  @override
  TestReadModel get readModel => _readModel;

  @override
  List<Type> get interestedEventTypes => [TestEvent1, TestEvent2];

  int get eventsHandled => _eventsHandled;

  @override
  Future<bool> handle(Event event) async {
    _eventsHandled++;

    if (event is TestEvent1) {
      _readModel = _readModel.copyWith(counter1: _readModel.counter1 + 1);
      return true;
    } else if (event is TestEvent2) {
      _readModel = _readModel.copyWith(counter2: _readModel.counter2 + 1);
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
    _readModel = TestReadModel.empty();
    _eventsHandled = 0;
  }

  @override
  Future<int> getCheckpoint() async {
    // Load checkpoint from Isar
    final checkpointEntity = await _isar.projectionCheckpoints
        .filter()
        .projectionIdEqualTo(_projectionId)
        .findFirst();

    return checkpointEntity?.lastProcessedSequence ?? 0;
  }

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {
    // Persist checkpoint to Isar
    await _isar.writeTxn(() async {
      // Find existing to preserve ID (for update)
      final existing = await _isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo(_projectionId)
          .findFirst();

      if (existing != null) {
        // Update existing
        existing.lastProcessedSequence = sequenceNumber;
        existing.lastUpdated = DateTime.now();
        existing.eventsProcessed++;
        await _isar.projectionCheckpoints.put(existing);
      } else {
        // Create new
        final entity = ProjectionCheckpoint()
          ..projectionId = _projectionId
          ..lastProcessedSequence = sequenceNumber
          ..lastUpdated = DateTime.now()
          ..eventsProcessed = 1;
        await _isar.projectionCheckpoints.put(entity);
      }
    });
  }
}

/// Simple read model for testing
class TestReadModel {
  final int counter1;
  final int counter2;

  const TestReadModel({required this.counter1, required this.counter2});

  factory TestReadModel.empty() =>
      const TestReadModel(counter1: 0, counter2: 0);

  TestReadModel copyWith({int? counter1, int? counter2}) {
    return TestReadModel(
      counter1: counter1 ?? this.counter1,
      counter2: counter2 ?? this.counter2,
    );
  }
}

/// Test events
class TestEvent1 extends Event {
  final String data;

  TestEvent1(this.data) : super();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['data'] = data;
    return map;
  }

  Map<String, dynamic> getEventData() => {'data': data};

  /// Factory for deserialization
  static TestEvent1 fromMap(Map<String, dynamic> map) {
    return TestEvent1(map['data'] as String);
  }
}

class TestEvent2 extends Event {
  final int value;

  TestEvent2(this.value) : super();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['value'] = value;
    return map;
  }

  Map<String, dynamic> getEventData() => {'value': value};

  /// Factory for deserialization
  static TestEvent2 fromMap(Map<String, dynamic> map) {
    return TestEvent2(map['value'] as int);
  }
}

void main() {
  group('Projection Checkpoint Persistence', () {
    late Directory tempDir;
    late Isar isar;
    late IsarEventStore eventStore;

    setUp(() async {
      // Register test event types for deserialization
      EventRegistry.register<TestEvent1>(
        'TestEvent1',
        (map) => TestEvent1.fromMap(map),
      );
      EventRegistry.register<TestEvent2>(
        'TestEvent2',
        (map) => TestEvent2.fromMap(map),
      );

      // Create temporary directory
      tempDir =
          await Directory.systemTemp.createTemp('eventador_checkpoint_test_');

      // Initialize Isar with all required schemas
      await initIsarCoreForTests();
      isar = await Isar.open(
        IsarEventStore.allSchemas,
        directory: tempDir.path,
        name: 'test_checkpoint',
      );

      eventStore = IsarEventStore(isar);
    });

    tearDown(() async {
      if (isar.isOpen) await isar.close();
      await tempDir.delete(recursive: true);
    });

    test('checkpoint persists to Isar and survives projection recreation',
        () async {
      final projectionId = 'test-projection-1';

      // Create first projection instance
      final projection1 = TestProjection(isar, projectionId);

      // Verify initial checkpoint is 0
      final initialCheckpoint = await projection1.getCheckpoint();
      expect(initialCheckpoint, equals(0));

      // Update checkpoint to 5
      await projection1.updateCheckpoint(5);

      // Verify checkpoint was updated
      final updatedCheckpoint = await projection1.getCheckpoint();
      expect(updatedCheckpoint, equals(5));

      // Create second projection instance (simulating app restart)
      final projection2 = TestProjection(isar, projectionId);

      // Verify checkpoint persisted across instances
      final restoredCheckpoint = await projection2.getCheckpoint();
      expect(restoredCheckpoint, equals(5));
    });

    test('checkpoint updates increment eventsProcessed counter', () async {
      final projectionId = 'test-projection-2';
      final projection = TestProjection(isar, projectionId);

      // Update checkpoint multiple times
      await projection.updateCheckpoint(1);
      await projection.updateCheckpoint(2);
      await projection.updateCheckpoint(3);

      // Verify eventsProcessed was incremented
      final checkpoint = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo(projectionId)
          .findFirst();

      expect(checkpoint, isNotNull);
      expect(checkpoint!.lastProcessedSequence, equals(3));
      expect(checkpoint.eventsProcessed, equals(3));
    });

    test('checkpoint stores metadata correctly', () async {
      final projectionId = 'test-projection-3';
      final projection = TestProjection(isar, projectionId);

      // Update checkpoint
      final beforeUpdate = DateTime.now();
      await projection.updateCheckpoint(10);
      final afterUpdate = DateTime.now();

      // Verify checkpoint metadata
      final checkpoint = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo(projectionId)
          .findFirst();

      expect(checkpoint, isNotNull);
      expect(checkpoint!.projectionId, equals(projectionId));
      expect(checkpoint.lastProcessedSequence, equals(10));
      expect(checkpoint.status, equals(ProjectionStatus.running));
      expect(
          checkpoint.lastUpdated
              .isAfter(beforeUpdate.subtract(const Duration(seconds: 1))),
          isTrue);
      expect(
          checkpoint.lastUpdated
              .isBefore(afterUpdate.add(const Duration(seconds: 1))),
          isTrue);
      expect(checkpoint.projectionVersion, equals(1));
    });

    test('multiple projections maintain separate checkpoints', () async {
      final projection1 = TestProjection(isar, 'projection-1');
      final projection2 = TestProjection(isar, 'projection-2');

      // Update different checkpoints
      await projection1.updateCheckpoint(10);
      await projection2.updateCheckpoint(20);

      // Verify each projection has its own checkpoint
      final checkpoint1 = await projection1.getCheckpoint();
      final checkpoint2 = await projection2.getCheckpoint();

      expect(checkpoint1, equals(10));
      expect(checkpoint2, equals(20));
    });

    test('checkpoint prevents duplicate event processing on restart', () async {
      final projectionId = 'test-projection-4';
      final aggregateId = 'test-aggregate-1';

      // Create projection and persist some events
      final projection1 = TestProjection(isar, projectionId);

      // Persist events to event store
      await eventStore.persistEvent(aggregateId, TestEvent1('event-1'), 0);
      await eventStore.persistEvent(aggregateId, TestEvent1('event-2'), 1);
      await eventStore.persistEvent(aggregateId, TestEvent1('event-3'), 2);

      // Get events and process them
      final events = await eventStore.getEvents(aggregateId, fromSequence: 0);
      expect(events.length, equals(3));

      for (var i = 0; i < events.length; i++) {
        await projection1.handle(events[i]);
        await projection1.updateCheckpoint(i + 1);
      }

      // Verify all events were processed
      expect(projection1.eventsHandled, equals(3));
      expect(projection1.readModel.counter1, equals(3));

      // Simulate app restart - create new projection instance
      final projection2 = TestProjection(isar, projectionId);

      // Get checkpoint to know where to resume
      final resumeFrom = await projection2.getCheckpoint();
      expect(resumeFrom, equals(3)); // Last processed sequence

      // Get events from checkpoint (should be empty since we're caught up)
      final newEvents =
          await eventStore.getEvents(aggregateId, fromSequence: resumeFrom);

      for (final event in newEvents) {
        await projection2.handle(event);
      }

      // Verify no duplicate processing occurred
      expect(projection2.eventsHandled, equals(0)); // No new events
      expect(
          projection2.readModel.counter1, equals(0)); // Read model starts fresh

      // Add a new event
      await eventStore.persistEvent(aggregateId, TestEvent1('event-4'), 3);

      // Process only the new event
      final newEvents2 =
          await eventStore.getEvents(aggregateId, fromSequence: resumeFrom);
      expect(newEvents2.length, equals(1));

      for (var i = 0; i < newEvents2.length; i++) {
        await projection2.handle(newEvents2[i]);
        await projection2.updateCheckpoint(resumeFrom + i + 1);
      }

      // Verify only new event was processed
      expect(projection2.eventsHandled, equals(1));
      expect(projection2.readModel.counter1, equals(1));

      // Verify checkpoint updated
      final finalCheckpoint = await projection2.getCheckpoint();
      expect(finalCheckpoint, equals(4));
    });

    test('checkpoint unique index prevents duplicate projection IDs', () async {
      final projectionId = 'test-projection-5';

      // Create checkpoint manually
      await isar.writeTxn(() async {
        final checkpoint = ProjectionCheckpoint()
          ..projectionId = projectionId
          ..lastProcessedSequence = 1
          ..lastUpdated = DateTime.now();
        await isar.projectionCheckpoints.put(checkpoint);
      });

      // Update the checkpoint (must preserve the ID)
      await isar.writeTxn(() async {
        // Find existing checkpoint
        final existing = await isar.projectionCheckpoints
            .filter()
            .projectionIdEqualTo(projectionId)
            .findFirst();

        expect(existing, isNotNull, reason: 'First checkpoint should exist');

        // Update it by preserving the ID
        final checkpoint = ProjectionCheckpoint()
          ..id = existing!.id // Preserve ID for update
          ..projectionId = projectionId
          ..lastProcessedSequence = 2
          ..lastUpdated = DateTime.now();
        await isar.projectionCheckpoints.put(checkpoint);
      });

      // Verify only one checkpoint exists (updated, not duplicated)
      final checkpoints = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo(projectionId)
          .findAll();

      expect(checkpoints.length, equals(1));
      expect(
          checkpoints.first.lastProcessedSequence, equals(2)); // Updated to 2
    });

    test('getCheckpoint returns 0 for new projection without checkpoint',
        () async {
      final projection = TestProjection(isar, 'new-projection');

      final checkpoint = await projection.getCheckpoint();
      expect(checkpoint, equals(0));
    });

    test('checkpoint can be queried and filtered', () async {
      // Create multiple checkpoints with different states
      await isar.writeTxn(() async {
        await isar.projectionCheckpoints.put(ProjectionCheckpoint()
          ..projectionId = 'proj-1'
          ..lastProcessedSequence = 100
          ..status = ProjectionStatus.running
          ..eventsProcessed = 100);

        await isar.projectionCheckpoints.put(ProjectionCheckpoint()
          ..projectionId = 'proj-2'
          ..lastProcessedSequence = 200
          ..status = ProjectionStatus.paused
          ..eventsProcessed = 200);

        await isar.projectionCheckpoints.put(ProjectionCheckpoint()
          ..projectionId = 'proj-3'
          ..lastProcessedSequence = 50
          ..status = ProjectionStatus.error
          ..eventsProcessed = 50);
      });

      // Query all checkpoints
      final allCheckpoints = await isar.projectionCheckpoints.where().findAll();
      expect(allCheckpoints.length, greaterThanOrEqualTo(3));

      // Query by status
      final runningCheckpoints = await isar.projectionCheckpoints
          .filter()
          .statusEqualTo(ProjectionStatus.running)
          .findAll();

      expect(runningCheckpoints.any((c) => c.projectionId == 'proj-1'), isTrue);

      // Query specific projection
      final proj2 = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo('proj-2')
          .findFirst();

      expect(proj2, isNotNull);
      expect(proj2!.lastProcessedSequence, equals(200));
      expect(proj2.status, equals(ProjectionStatus.paused));
    });
  });
}
