/// Audit F19: an `ActorRef` in message metadata (`replyTo`, `sender`) is a
/// handle into the running actor system. It must be usable in memory,
/// must not reach storage, and a stringified ref left behind by an earlier
/// release must not break `replyTo` on replay.
library;

import 'dart:io';

import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

class Recorder extends Actor {
  @override
  Future<void> onMessage(dynamic message) async {}
}

class Pinged extends Event {
  Pinged({super.metadata, super.eventId});

  static Pinged fromMap(Map<String, dynamic> map) => Pinged(
        eventId: map['eventId'] as String?,
        metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      );
}

class Ping extends Command {
  Ping({super.metadata, super.replyTo, super.commandId});

  static Ping fromMap(Map<String, dynamic> map) => Ping(
        commandId: map['commandId'] as String?,
        metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      );
}

void main() {
  late LocalActorSystem system;
  late ActorRef ref;

  setUp(() async {
    system = LocalActorSystem();
    ref = await system.spawn('recorder', () => Recorder());
    EventRegistry.register<Pinged>('Pinged', Pinged.fromMap);
    CommandRegistry.register<Ping>('Ping', Ping.fromMap);
  });

  tearDown(() async {
    await system.shutdown();
    EventRegistry.clear();
    CommandRegistry.clear();
  });

  group('Event', () {
    test('replyTo is available in memory but not in toMap()', () {
      final event = Pinged(metadata: {'replyTo': ref, 'userId': 'u1'});

      expect(event.replyTo, same(ref));
      expect(event.metadata['replyTo'], same(ref));
      expect(event.persistableMetadata, {'userId': 'u1'});
      expect(
          (event.toMap()['metadata'] as Map).containsKey('replyTo'), isFalse);
      expect((event.toMap()['metadata'] as Map)['userId'], 'u1');
    });

    test('metadata without refs is passed through untouched', () {
      final event = Pinged(metadata: {'userId': 'u1', 'n': 1});
      expect(event.toMap()['metadata'], {'userId': 'u1', 'n': 1});
    });

    test('a stored event has no replyTo and does not throw', () {
      final event = Pinged(metadata: {'replyTo': ref, 'userId': 'u1'});

      final restored = CborSerializer.deserializeEvent(
          CborSerializer.serializeEvent(event), 'Pinged');

      expect(restored.replyTo, isNull);
      expect(restored.metadata, {'userId': 'u1'});
    });

    test('a stringified ref written by an earlier release is ignored', () {
      // 2.x stored `replyTo` as the ref's toString().
      final restored = EventRegistry.fromMap({
        'type': 'Pinged',
        'metadata': {'replyTo': ref.toString()},
      });

      expect(restored.replyTo, isNull);
      expect(restored.metadata['replyTo'], ref.toString(),
          reason: 'the raw metadata is preserved for the caller');
    });
  });

  group('Command', () {
    test('replyTo from metadata is honoured in memory but not stored', () {
      final command = Ping(metadata: {'replyTo': ref, 'k': 'v'});

      expect(command.replyTo, same(ref));
      expect(command.persistableMetadata, {'k': 'v'});
      expect(
          (command.toMap()['metadata'] as Map).containsKey('replyTo'), isFalse);
    });

    test('a stored command with a stringified replyTo rebuilds cleanly', () {
      final command = CommandRegistry.fromMap({
        'type': 'Ping',
        'metadata': {'replyTo': ref.toString(), 'k': 'v'},
      });

      expect(command.replyTo, isNull);
      expect(command.metadata['k'], 'v');
    });
  });

  group('IsarEventStore', () {
    late Directory tempDir;
    late IsarEventStore eventStore;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('eventador_metadata_');
      await initIsarCoreForTests();
      eventStore = await IsarEventStore.create(
        directory: tempDir.path,
        name: 'metadata_${DateTime.now().microsecondsSinceEpoch}',
      );
    });

    tearDown(() async {
      await eventStore.close();
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('the envelope metadata column omits the ref', () async {
      await eventStore.persistEvent(
          'p-1', Pinged(metadata: {'replyTo': ref, 'userId': 'u1'}), 0);

      final envelope = await eventStore.isar.eventEnvelopes.where().findFirst();
      final stored = CborSerializer.deserializeMetadata(envelope!.metadataPayload);
      expect(stored, {'userId': 'u1'});

      final events = await eventStore.getEvents('p-1');
      expect(events.single.replyTo, isNull);
      expect(events.single.metadata, {'userId': 'u1'});
    });
  });
}
