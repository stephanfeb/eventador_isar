/// Tests for the live event stream and the id generation behaviour changed
/// in 3.0.0:
///
/// - live subscriptions are gap-free and duplicate-free even when events are
///   persisted while the historical replay is still running;
/// - per-actor streams only carry that actor's events;
/// - event and command ids never collide, however fast they are created.
library;

import 'dart:io';

import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

class StreamTestEvent extends Event {
  final String data;

  StreamTestEvent(this.data, {super.eventId, super.timestamp, super.metadata});

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'data': data};

  static StreamTestEvent fromMap(Map<String, dynamic> map) => StreamTestEvent(
        map['data'] as String,
        eventId: map['eventId'] as String,
        timestamp: map['timestamp'] is DateTime
            ? map['timestamp'] as DateTime
            : DateTime.parse(map['timestamp'] as String),
      );
}

class NoopCommand extends Command {
  NoopCommand({super.commandId});
}

void main() {
  group('id generation', () {
    test('event ids are unique under rapid creation', () {
      final ids = {for (var i = 0; i < 5000; i++) StreamTestEvent('x').eventId};
      expect(ids.length, 5000);
    });

    test('command ids are unique under rapid creation', () {
      final ids = {for (var i = 0; i < 5000; i++) NoopCommand().commandId};
      expect(ids.length, 5000);
    });
  });

  group('IsarEventStore streams', () {
    late Directory tempDir;
    late IsarEventStore store;
    var counter = 0;

    setUpAll(() async {
      await initIsarCoreForTests();
      EventRegistry.register('StreamTestEvent', StreamTestEvent.fromMap);
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('event_stream_test_');
      store = await IsarEventStore.create(
        directory: tempDir.path,
        name: 'stream_${counter++}',
      );
    });

    tearDown(() async {
      await store.close();
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    Future<void> persistMany(String pid, int from, int count) async {
      for (var i = 0; i < count; i++) {
        await store.persistEvent(
            pid, StreamTestEvent('$pid-${from + i}'), from + i);
      }
    }

    test(
        'live stream has no gaps or duplicates when events arrive during replay',
        () async {
      await persistMany('a', 0, 20);

      final received = <(Event, int)>[];
      final sub = store.allEventsWithSequence().listen(received.add);

      // Persist while the replay is (or may still be) running.
      await persistMany('b', 0, 20);
      await Future.delayed(const Duration(milliseconds: 200));

      final ids = received.map((r) => r.$2).toList();
      expect(ids, List.generate(40, (i) => i + 1),
          reason: 'envelope ids must be contiguous and strictly increasing');
      expect(received.map((r) => (r.$1 as StreamTestEvent).data).take(20),
          List.generate(20, (i) => 'a-$i'));

      await sub.cancel();
    });

    test('live stream resumes from a checkpoint', () async {
      await persistMany('a', 0, 10);

      final received = <int>[];
      final sub = store
          .allEventsWithSequence(fromSequence: 7)
          .listen((r) => received.add(r.$2));
      await persistMany('a', 10, 2);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(received, [8, 9, 10, 11, 12]);
      await sub.cancel();
    });

    test('eventsByPersistenceId only carries that actor, live included',
        () async {
      await persistMany('a', 0, 3);
      await persistMany('b', 0, 3);

      final received = <String>[];
      final sub = store
          .eventsByPersistenceId('a', fromSequence: 1)
          .listen((e) => received.add((e as StreamTestEvent).data));

      await persistMany('b', 3, 2);
      await persistMany('a', 3, 2);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(received, ['a-1', 'a-2', 'a-3', 'a-4']);
      await sub.cancel();
    });

    test('non-live streams complete after the replay', () async {
      await persistMany('a', 0, 5);
      final events = await store.allEvents(live: false).toList();
      expect(events.length, 5);
      final ownEvents = await store
          .eventsByPersistenceId('a', fromSequence: 3, live: false)
          .toList();
      expect(ownEvents.map((e) => (e as StreamTestEvent).data), ['a-3', 'a-4']);
    });

    test('getEvents honours the (from, to] range', () async {
      await persistMany('a', 0, 10);
      final events = await store.getEvents('a', fromSequence: 2, toSequence: 5);
      expect(events.map((e) => (e as StreamTestEvent).data),
          ['a-2', 'a-3', 'a-4']);
      expect(await store.getHighestSequenceNumber('a'), 10);
      expect(await store.getHighestSequenceNumber('nobody'), 0);
    });

    test('cancelling a live subscription stops delivery', () async {
      await persistMany('a', 0, 2);
      final received = <int>[];
      final sub =
          store.allEventsWithSequence().listen((r) => received.add(r.$2));
      await Future.delayed(const Duration(milliseconds: 50));
      await sub.cancel();
      await persistMany('a', 2, 2);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(received, [1, 2]);
    });
  });
}
