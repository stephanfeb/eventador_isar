// Phase 1 Week 3 Tests - Isar Event Store Implementation
// Tests for CBOR serialization, event persistence, and snapshot functionality

import 'dart:io';
import 'package:test/test.dart';

import 'support/isar_core.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';

// Test event implementations
class TestEvent extends Event with SerializableEvent, VersionedEvent {
  final String data;
  final int value;

  TestEvent({
    required this.data,
    required this.value,
    super.eventId,
    super.timestamp,
    super.metadata,
  });

  @override
  Map<String, dynamic> getEventData() {
    return {
      'data': data,
      'value': value,
    };
  }

  static TestEvent fromMap(Map<String, dynamic> map) {
    return TestEvent(
      data: map['data'] as String,
      value: map['value'] as int,
      eventId: map['eventId'] as String?,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is DateTime
              ? map['timestamp'] as DateTime
              : DateTime.parse(map['timestamp'] as String))
          : null,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestEvent &&
        other.data == data &&
        other.value == value &&
        other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(data, value, eventId);
}

class AnotherTestEvent extends Event with SerializableEvent {
  final String message;

  AnotherTestEvent({
    required this.message,
    super.eventId,
    super.timestamp,
    super.metadata,
  });

  @override
  Map<String, dynamic> getEventData() {
    return {
      'message': message,
    };
  }

  static AnotherTestEvent fromMap(Map<String, dynamic> map) {
    return AnotherTestEvent(
      message: map['message'] as String,
      eventId: map['eventId'] as String?,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is DateTime
              ? map['timestamp'] as DateTime
              : DateTime.parse(map['timestamp'] as String))
          : null,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnotherTestEvent &&
        other.message == message &&
        other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(message, eventId);
}

// Test state class
class TestState {
  final int counter;
  final String name;
  final DateTime lastUpdated;

  const TestState({
    required this.counter,
    required this.name,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'counter': counter,
      'name': name,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static TestState fromMap(Map<String, dynamic> map) {
    return TestState(
      counter: map['counter'] as int,
      name: map['name'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestState &&
        other.counter == counter &&
        other.name == name &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode => Object.hash(counter, name, lastUpdated);
}

void main() {
  group('Phase 1 Week 3 - Isar Event Store Implementation', () {
    late Directory tempDir;
    late IsarEventStore eventStore;
    late String isarName;

    setUpAll(() async {
      // Register test events
      EventRegistry.register<TestEvent>(
        'TestEvent',
        TestEvent.fromMap,
      );
      EventRegistry.register<AnotherTestEvent>(
        'AnotherTestEvent',
        AnotherTestEvent.fromMap,
      );
    });

    setUp(() async {
      // Create temporary directory for each test
      tempDir = await Directory.systemTemp.createTemp('eventador_test_');
      isarName = 'test_eventador_${DateTime.now().microsecondsSinceEpoch}';
      await initIsarCoreForTests();
      eventStore = await IsarEventStore.create(
        directory: tempDir.path,
        name: isarName,
      );
    });

    tearDown(() async {
      await eventStore.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    tearDownAll(() {
      EventRegistry.clear();
    });

    group('CBOR Serialization', () {
      test('should serialize and deserialize events correctly', () {
        final event = TestEvent(
          data: 'test data',
          value: 42,
          metadata: {'userId': 'user123', 'sessionId': 'session456'},
        );

        final serialized = CborSerializer.serializeEvent(event);
        expect(serialized, isA<List<int>>());
        expect(serialized.isNotEmpty, isTrue);

        final deserialized = CborSerializer.deserializeEvent(
          serialized,
          'TestEvent',
        );

        expect(deserialized, isA<TestEvent>());
        final testEvent = deserialized as TestEvent;
        expect(testEvent.data, equals('test data'));
        expect(testEvent.value, equals(42));
        expect(testEvent.metadata['userId'], equals('user123'));
        expect(testEvent.metadata['sessionId'], equals('session456'));
      });

      test('should serialize and deserialize state objects correctly', () {
        final state = TestState(
          counter: 100,
          name: 'test state',
          lastUpdated: DateTime.now(),
        );

        final serialized = CborSerializer.serializeState(state);
        expect(serialized, isA<List<int>>());
        expect(serialized.isNotEmpty, isTrue);

        final deserialized = CborSerializer.deserializeState(
          serialized,
          'TestState',
        );

        expect(deserialized, isA<Map>());
        final stateMap = deserialized as Map<String, dynamic>;
        expect(stateMap['counter'], equals(100));
        expect(stateMap['name'], equals('test state'));
      });

      test('should serialize and deserialize metadata correctly', () {
        final metadata = {
          'userId': 'user123',
          'sessionId': 'session456',
          'correlationId': 'corr789',
        };

        final serialized = CborSerializer.serializeMetadata(metadata);
        expect(serialized, isA<List<int>>());
        expect(serialized.isNotEmpty, isTrue);

        final deserialized = CborSerializer.deserializeMetadata(serialized);
        expect(deserialized, equals(metadata));
      });

      test('should handle complex data types in serialization', () {
        final event = TestEvent(
          data: 'complex data with special chars: äöü 中文 🚀',
          value: -42,
          metadata: {
            'timestamp': DateTime.now().toIso8601String(),
            'nested': {'key': 'value', 'number': 123},
            'list': ['item1', 'item2', 'item3'],
          },
        );

        final serialized = CborSerializer.serializeEvent(event);
        final deserialized = CborSerializer.deserializeEvent(
          serialized,
          'TestEvent',
        ) as TestEvent;

        expect(deserialized.data, equals(event.data));
        expect(deserialized.value, equals(event.value));
      });
    });

    group('Event Persistence', () {
      test('should persist and retrieve a single event', () async {
        final event = TestEvent(data: 'test', value: 1);
        const persistenceId = 'test-actor-1';

        await eventStore.persistEvent(persistenceId, event, 0);

        final events = await eventStore.getEvents(persistenceId);
        expect(events, hasLength(1));

        final retrievedEvent = events.first as TestEvent;
        expect(retrievedEvent.data, equals('test'));
        expect(retrievedEvent.value, equals(1));
      });

      test('should persist multiple events atomically', () async {
        final events = [
          TestEvent(data: 'event1', value: 1),
          TestEvent(data: 'event2', value: 2),
          TestEvent(data: 'event3', value: 3),
        ];
        const persistenceId = 'test-actor-2';

        await eventStore.persistEvents(persistenceId, events, 0);

        final retrievedEvents = await eventStore.getEvents(persistenceId);
        expect(retrievedEvents, hasLength(3));

        for (int i = 0; i < 3; i++) {
          final event = retrievedEvents[i] as TestEvent;
          expect(event.data, equals('event${i + 1}'));
          expect(event.value, equals(i + 1));
        }
      });

      test('should maintain sequence numbers correctly', () async {
        const persistenceId = 'test-actor-3';

        // Persist first event
        await eventStore.persistEvent(
          persistenceId,
          TestEvent(data: 'first', value: 1),
          0,
        );

        // Check sequence number
        final seq1 = await eventStore.getHighestSequenceNumber(persistenceId);
        expect(seq1, equals(1));

        // Persist second event
        await eventStore.persistEvent(
          persistenceId,
          TestEvent(data: 'second', value: 2),
          1,
        );

        // Check sequence number
        final seq2 = await eventStore.getHighestSequenceNumber(persistenceId);
        expect(seq2, equals(2));

        // Verify events are in correct order
        final events = await eventStore.getEvents(persistenceId);
        expect(events, hasLength(2));
        expect((events[0] as TestEvent).data, equals('first'));
        expect((events[1] as TestEvent).data, equals('second'));
      });

      test('should enforce optimistic concurrency control', () async {
        const persistenceId = 'test-actor-4';

        // Persist first event
        await eventStore.persistEvent(
          persistenceId,
          TestEvent(data: 'first', value: 1),
          0,
        );

        // Try to persist with wrong expected version
        expect(
          () => eventStore.persistEvent(
            persistenceId,
            TestEvent(data: 'second', value: 2),
            0, // Wrong expected version
          ),
          throwsA(isA<ConcurrencyException>()),
        );
      });

      test('should retrieve events by sequence range', () async {
        const persistenceId = 'test-actor-5';

        // Persist multiple events
        final events = List.generate(
          5,
          (i) => TestEvent(data: 'event$i', value: i),
        );
        await eventStore.persistEvents(persistenceId, events, 0);

        // Get events from sequence 2 to 4
        final rangeEvents = await eventStore.getEvents(
          persistenceId,
          fromSequence: 2,
          toSequence: 4,
        );

        expect(rangeEvents, hasLength(2));
        expect((rangeEvents[0] as TestEvent).data, equals('event2'));
        expect((rangeEvents[1] as TestEvent).data, equals('event3'));
      });

      test('should handle different event types', () async {
        const persistenceId = 'test-actor-6';

        final events = [
          TestEvent(data: 'test', value: 1),
          AnotherTestEvent(message: 'hello'),
          TestEvent(data: 'test2', value: 2),
        ];

        await eventStore.persistEvents(persistenceId, events, 0);

        final retrievedEvents = await eventStore.getEvents(persistenceId);
        expect(retrievedEvents, hasLength(3));
        expect(retrievedEvents[0], isA<TestEvent>());
        expect(retrievedEvents[1], isA<AnotherTestEvent>());
        expect(retrievedEvents[2], isA<TestEvent>());
      });

      test('should return empty list for non-existent persistence ID',
          () async {
        final events = await eventStore.getEvents('non-existent');
        expect(events, isEmpty);
      });

      test(
          'should return 0 for highest sequence of non-existent persistence ID',
          () async {
        final seq = await eventStore.getHighestSequenceNumber('non-existent');
        expect(seq, equals(0));
      });
    });

    group('Snapshot Functionality', () {
      test('should save and load snapshots', () async {
        const persistenceId = 'test-actor-7';
        final state = TestState(
          counter: 42,
          name: 'test state',
          lastUpdated: DateTime.now(),
        );

        await eventStore.saveSnapshot(persistenceId, state, 10);

        final snapshot = await eventStore.loadSnapshot(persistenceId);
        expect(snapshot, isNotNull);
        expect(snapshot!.sequenceNumber, equals(10));
        expect(snapshot.state, isA<Map>());

        final stateMap = snapshot.state as Map<String, dynamic>;
        expect(stateMap['counter'], equals(42));
        expect(stateMap['name'], equals('test state'));
      });

      test('should return null for non-existent snapshot', () async {
        final snapshot = await eventStore.loadSnapshot('non-existent');
        expect(snapshot, isNull);
      });

      test('should replace existing snapshot', () async {
        const persistenceId = 'test-actor-8';

        // Save first snapshot
        final state1 = TestState(
          counter: 1,
          name: 'first',
          lastUpdated: DateTime.now(),
        );
        await eventStore.saveSnapshot(persistenceId, state1, 5);

        // Save second snapshot (should replace first)
        final state2 = TestState(
          counter: 2,
          name: 'second',
          lastUpdated: DateTime.now(),
        );
        await eventStore.saveSnapshot(persistenceId, state2, 10);

        // Should get the second snapshot
        final snapshot = await eventStore.loadSnapshot(persistenceId);
        expect(snapshot, isNotNull);
        expect(snapshot!.sequenceNumber, equals(10));

        final stateMap = snapshot.state as Map<String, dynamic>;
        expect(stateMap['counter'], equals(2));
        expect(stateMap['name'], equals('second'));
      });

      test('should delete snapshots', () async {
        const persistenceId = 'test-actor-9';
        final state = TestState(
          counter: 42,
          name: 'test',
          lastUpdated: DateTime.now(),
        );

        await eventStore.saveSnapshot(persistenceId, state, 5);

        // Verify snapshot exists
        var snapshot = await eventStore.loadSnapshot(persistenceId);
        expect(snapshot, isNotNull);

        // Delete snapshots
        await eventStore.deleteOldSnapshots(persistenceId, 0);

        // Verify snapshot is deleted
        snapshot = await eventStore.loadSnapshot(persistenceId);
        expect(snapshot, isNull);
      });
    });

    group('Error Handling', () {
      test('should handle serialization errors gracefully', () {
        expect(
          () => CborSerializer.deserializeEvent([1, 2, 3], 'UnknownEvent'),
          throwsA(isA<EventDeserializationException>()),
        );
      });

      test('should handle database errors gracefully', () async {
        // Close the event store to simulate database error
        await eventStore.close();

        expect(
          () => eventStore.persistEvent(
            'test',
            TestEvent(data: 'test', value: 1),
            0,
          ),
          throwsA(anything),
        );
      });

      test('should handle invalid event types during deserialization',
          () async {
        const persistenceId = 'test-actor-10';

        // Persist an event
        await eventStore.persistEvent(
          persistenceId,
          TestEvent(data: 'test', value: 1),
          0,
        );

        // Clear the registry to simulate unknown event type
        EventRegistry.clear();

        // This should throw an EventStoreException because TestEvent is no longer registered
        await expectLater(
          eventStore.getEvents(persistenceId),
          throwsA(isA<EventStoreException>()),
        );

        // Re-register events for subsequent tests
        EventRegistry.register<TestEvent>(
          'TestEvent',
          TestEvent.fromMap,
        );
        EventRegistry.register<AnotherTestEvent>(
          'AnotherTestEvent',
          AnotherTestEvent.fromMap,
        );
      });
    });

    group('Performance and Edge Cases', () {
      test('should handle empty event list in persistEvents', () async {
        const persistenceId = 'test-actor-11';

        // Should not throw error
        await eventStore.persistEvents(persistenceId, [], 0);

        final events = await eventStore.getEvents(persistenceId);
        expect(events, isEmpty);
      });

      test('should handle large event data', () async {
        const persistenceId = 'test-actor-12';

        // Create event with large data
        final largeData = 'x' * 10000; // 10KB string
        final event = TestEvent(data: largeData, value: 1);

        await eventStore.persistEvent(persistenceId, event, 0);

        final events = await eventStore.getEvents(persistenceId);
        expect(events, hasLength(1));
        expect((events.first as TestEvent).data, equals(largeData));
      });

      test('should handle concurrent access correctly', () async {
        const persistenceId = 'test-actor-13';

        // Simulate concurrent writes (should be handled by Isar transactions)
        final futures = List.generate(10, (i) async {
          try {
            await eventStore.persistEvent(
              '$persistenceId-$i',
              TestEvent(data: 'concurrent-$i', value: i),
              0,
            );
            return true;
          } catch (e) {
            return false;
          }
        });

        final results = await Future.wait(futures);
        expect(results.every((r) => r), isTrue);
      });

      test('should maintain data integrity across restarts', () async {
        const persistenceId = 'test-actor-14';
        final event = TestEvent(data: 'persistent', value: 42);

        // Persist event
        await eventStore.persistEvent(persistenceId, event, 0);

        // Close and reopen event store
        await eventStore.close();
        eventStore = await IsarEventStore.create(
          directory: tempDir.path,
          name: isarName,
        );

        // Verify event is still there
        final events = await eventStore.getEvents(persistenceId);
        expect(events, hasLength(1));
        expect((events.first as TestEvent).data, equals('persistent'));
        expect((events.first as TestEvent).value, equals(42));
      });
    });
  });
}
