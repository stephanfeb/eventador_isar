/// Events are stored one byte for each byte (4.2.0), journals written before
/// still read, and an event too large for Isar is refused instead of being
/// written where the journal index does not find it.
library;

import 'dart:io';

import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

class _Note extends Event with SerializableEvent {
  final String text;

  _Note(this.text, {super.eventId, super.timestamp, super.metadata});

  @override
  String get typeName => 'BytesTestNote';

  @override
  Map<String, dynamic> getEventData() => {'text': text};

  static _Note fromMap(Map<String, dynamic> map) => _Note(
        map['text'] as String,
        eventId: map['eventId'] as String?,
        timestamp: map['timestamp'] is DateTime ? map['timestamp'] as DateTime : null,
      );
}

void main() {
  late Directory dir;
  late IsarEventStore store;

  setUpAll(() => EventRegistry.register<_Note>('BytesTestNote', _Note.fromMap));

  setUp(() async {
    await initIsarCoreForTests();
    dir = await Directory.systemTemp.createTemp('eventador_bytes_');
    store = await IsarEventStore.create(directory: dir.path, name: 'bytes_${DateTime.now().microsecondsSinceEpoch}');
  });

  tearDown(() async {
    await store.close();
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  Future<List<EventEnvelope>> journal(String id) =>
      store.isar.eventEnvelopes.where().persistenceIdEqualToAnySequenceNumber(id).findAll();

  test('a new event is stored in the byte field, and reads back', () async {
    await store.persistEvent('p', _Note('hello'), 0);
    await store.persistEvents('p', [_Note('a'), _Note('b')], 1);

    final stored = await journal('p');
    expect(stored.map((e) => e.sequenceNumber), [1, 2, 3]);
    for (final e in stored) {
      expect(e.eventBytes, isNotEmpty);
      expect(e.eventData, isEmpty, reason: 'not stored eight bytes a byte any more');
      expect(e.metadataBytes, isNotNull);
    }
    expect((await store.getEvents('p')).cast<_Note>().map((e) => e.text), ['hello', 'a', 'b']);
  });

  test('an event written before 4.2.0, in the integer field, still reads and is the head', () async {
    final old = EventEnvelope()
      ..persistenceId = 'p'
      ..sequenceNumber = 1
      ..eventData = CborSerializer.serializeEvent(_Note('old'))
      ..metadataData = CborSerializer.serializeMetadata(const {})
      ..eventType = 'BytesTestNote'
      ..timestamp = DateTime.now()
      ..eventId = 'old-1'
      ..schemaVersion = 1;
    await store.isar.writeTxn(() => store.isar.eventEnvelopes.put(old));

    await store.persistEvent('p', _Note('new'), 1);

    expect((await store.getEvents('p')).cast<_Note>().map((e) => e.text), ['old', 'new']);
  });

  test('a backup copy of either kind restores to the byte field', () async {
    await store.persistEvent('p', _Note('kept'), 0);
    final written = (await journal('p')).single;
    final legacy = EventEnvelope()
      ..persistenceId = 'q'
      ..sequenceNumber = 1
      ..eventData = written.payload
      ..metadataData = written.metadataPayload
      ..eventType = written.eventType
      ..timestamp = written.timestamp
      ..eventId = 'legacy'
      ..schemaVersion = 1;

    for (final source in [written, legacy]) {
      final restored = EventEnvelope.fromJson(source.toJson());
      expect(restored.eventBytes, written.payload);
      expect(restored.eventData, isEmpty);
      expect(restored.metadataPayload, written.metadataPayload);
    }
  });

  test('an event over the limit is refused, nothing is written, and the journal goes on', () async {
    await store.persistEvent('p', _Note('first'), 0);

    await expectLater(
      store.persistEvent('p', _Note('x' * (IsarEventStore.maxPayloadBytes + 1)), 1),
      throwsA(isA<EventTooLargeException>()),
    );
    await expectLater(
      store.persistEvents('p', [_Note('small'), _Note('y' * (IsarEventStore.maxPayloadBytes + 1))], 1),
      throwsA(isA<EventTooLargeException>()),
      reason: 'a batch with one such event is refused whole',
    );

    expect((await journal('p')).map((e) => e.sequenceNumber), [1]);
    await store.persistEvent('p', _Note('second'), 1);
    expect((await store.getEvents('p')).cast<_Note>().map((e) => e.text), ['first', 'second']);
  });

  test('an event of several megabytes, eight times too large before, is stored and indexed', () async {
    await store.persistEvent('p', _Note('z' * (3 * 1024 * 1024)), 0);
    await store.persistEvent('p', _Note('after'), 1);

    expect(await store.getHighestSequenceNumber('p'), 2);
  });
}
