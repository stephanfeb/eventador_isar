/// Audit F17: type identity in storage must not depend on the Dart class
/// name. `Event`, `Command` and `State` expose an overridable `typeName`,
/// every persistence site records it, and the registries accept aliases so
/// a renamed type can still read the rows written under its old name.
library;

import 'dart:io';

import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

/// An event whose stored identity is independent of its class name.
class AccountOpened extends Event with VersionedEvent {
  final String owner;

  AccountOpened(this.owner, {super.eventId, super.metadata});

  @override
  String get typeName => 'account.opened';

  @override
  Map<String, dynamic> toMap() => super.toMap()..['owner'] = owner;

  static AccountOpened fromMap(Map<String, dynamic> map) => AccountOpened(
        map['owner'] as String,
        eventId: map['eventId'] as String?,
        metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      );
}

/// An event that keeps the default: its class name.
class PlainEvent extends Event {
  PlainEvent();

  static PlainEvent fromMap(Map<String, dynamic> map) => PlainEvent();
}

class OpenAccount extends Command {
  final String owner;

  OpenAccount(this.owner, {super.commandId});

  @override
  String get typeName => 'account.open';

  @override
  Map<String, dynamic> toMap() => super.toMap()..['owner'] = owner;

  static OpenAccount fromMap(Map<String, dynamic> map) =>
      OpenAccount(map['owner'] as String,
          commandId: map['commandId'] as String?);
}

class AccountState extends State {
  final int balance;

  AccountState(this.balance, {super.version, super.lastModified});

  @override
  String get typeName => 'account.state';

  @override
  State copyWith({int? version, DateTime? lastModified}) => AccountState(
        balance,
        version: version ?? this.version,
        lastModified: lastModified ?? this.lastModified,
      );

  @override
  Map<String, dynamic> toMap() => super.toMap()..['balance'] = balance;

  static AccountState fromMap(Map<String, dynamic> map) =>
      AccountState(map['balance'] as int, version: map['version'] as int);
}

void main() {
  tearDown(() {
    EventRegistry.clear();
    CommandRegistry.clear();
    StateRegistry.clear();
    EventMigrationManager.clear();
  });

  group('typeName', () {
    test('defaults to the class name, so existing journals still match', () {
      expect(PlainEvent().typeName, 'PlainEvent');
      expect(PlainEvent().toMap()['type'], 'PlainEvent');
      expect(TestOnlyCommand().typeName, 'TestOnlyCommand');
      expect(TestOnlyCommand().toMap()['type'], 'TestOnlyCommand');
      expect(AccountState(0).copyWith().runtimeType, AccountState);
    });

    test('an override is what gets written to the map', () {
      expect(AccountOpened('ann').toMap()['type'], 'account.opened');
      expect(OpenAccount('ann').toMap()['type'], 'account.open');
      expect(AccountState(5).toMap()['type'], 'account.state');
    });

    test('events round-trip through the registry under the stable name', () {
      EventRegistry.register<AccountOpened>(
          'account.opened', AccountOpened.fromMap);
      final original = AccountOpened('ann');

      final restored =
          EventRegistry.fromCbor(original.toCbor()) as AccountOpened;

      expect(restored.owner, 'ann');
      expect(restored.eventId, original.eventId);
      expect(EventRegistry.isRegistered('AccountOpened'), isFalse,
          reason: 'the class name is not the identity any more');
    });

    test('commands round-trip through the registry under the stable name', () {
      CommandRegistry.register<OpenAccount>(
          'account.open', OpenAccount.fromMap);

      final restored =
          CommandRegistry.fromMap(OpenAccount('bob').toMap()) as OpenAccount;

      expect(restored.owner, 'bob');
      expect(CommandRegistry.isRegistered('account.open'), isTrue);
      expect(CommandRegistry.isRegistered('OpenAccount'), isFalse);
    });

    test('states round-trip through the registry under the stable name', () {
      StateRegistry.register<AccountState>(
          'account.state', AccountState.fromMap);

      final restored =
          StateRegistry.fromMap(AccountState(7, version: 3).toMap())
              as AccountState;

      expect(restored.balance, 7);
      expect(restored.version, 3);
    });

    test('CborSerializer.deserializeEvent uses the stored type name', () {
      EventRegistry.register<AccountOpened>(
          'account.opened', AccountOpened.fromMap);
      final bytes = CborSerializer.serializeEvent(AccountOpened('ann'));

      final restored = CborSerializer.deserializeEvent(bytes, 'account.opened');

      expect(restored, isA<AccountOpened>());
      expect(
        () => CborSerializer.deserializeEvent(bytes, 'AccountOpened'),
        throwsA(isA<EventDeserializationException>()),
        reason: 'the envelope column and payload must agree',
      );
    });

    test('migrations are keyed by typeName', () {
      EventMigrationManager.registerMigration<AccountOpened>(
        'account.opened',
        1,
        2,
        (event) => AccountOpened('${event.owner}!'),
      );

      final migrated = EventMigrationManager.migrate(AccountOpened('ann'), 2)
          as AccountOpened;

      expect(migrated.owner, 'ann!');
      expect(EventMigrationManager.canMigrate('account.opened', 1, 2), isTrue);
      expect(EventMigrationManager.canMigrate('AccountOpened', 1, 2), isFalse);
    });
  });

  group('registry aliases', () {
    test('an alias resolves rows stored under an old event name', () {
      EventRegistry.register<AccountOpened>(
        'account.opened',
        AccountOpened.fromMap,
        schemaVersion: 2,
        aliases: ['AccountOpenedEvent'],
      );
      // A row written by the previous release under the class name.
      final legacy = AccountOpened('ann').toMap()
        ..['type'] = 'AccountOpenedEvent';

      final restored = EventRegistry.fromMap(legacy) as AccountOpened;

      expect(restored.owner, 'ann');
      expect(EventRegistry.isRegistered('AccountOpenedEvent'), isTrue);
      expect(EventRegistry.resolve('AccountOpenedEvent'), 'account.opened');
      expect(EventRegistry.getSchemaVersion('AccountOpenedEvent'), 2);
      expect(EventRegistry.getRegisteredTypes(), ['account.opened'],
          reason: 'aliases are not types of their own');
    });

    test('registerAlias can be called after register', () {
      EventRegistry.register<AccountOpened>(
          'account.opened', AccountOpened.fromMap);
      EventRegistry.registerAlias('AccountOpenedEvent', 'account.opened');

      final legacy = AccountOpened('ann').toMap()
        ..['type'] = 'AccountOpenedEvent';
      expect(EventRegistry.fromMap(legacy), isA<AccountOpened>());
    });

    test('an aliased payload deserializes against either envelope name', () {
      EventRegistry.register<AccountOpened>(
          'account.opened', AccountOpened.fromMap,
          aliases: ['AccountOpenedEvent']);
      final legacyMap = AccountOpened('ann').toMap()
        ..['type'] = 'AccountOpenedEvent';
      final legacyBytes = CborSerializer.serializeMetadata(legacyMap);

      expect(CborSerializer.deserializeEvent(legacyBytes, 'AccountOpenedEvent'),
          isA<AccountOpened>());
      expect(CborSerializer.deserializeEvent(legacyBytes, 'account.opened'),
          isA<AccountOpened>());
    });

    test('migrations registered under an alias apply to the new name', () {
      EventRegistry.registerAlias('AccountOpenedEvent', 'account.opened');
      EventMigrationManager.registerMigration<AccountOpened>(
        'AccountOpenedEvent',
        1,
        2,
        (event) => AccountOpened('${event.owner}!'),
      );

      final migrated = EventMigrationManager.migrate(AccountOpened('ann'), 2)
          as AccountOpened;

      expect(migrated.owner, 'ann!');
    });

    test('command and state registries accept aliases too', () {
      CommandRegistry.register<OpenAccount>('account.open', OpenAccount.fromMap,
          aliases: ['OpenAccountCommand']);
      StateRegistry.register<AccountState>(
          'account.state', AccountState.fromMap,
          aliases: ['AccountStateV1']);

      final command = OpenAccount('bob').toMap()
        ..['type'] = 'OpenAccountCommand';
      final state = AccountState(1).toMap()..['type'] = 'AccountStateV1';

      expect(CommandRegistry.fromMap(command), isA<OpenAccount>());
      expect(StateRegistry.fromMap(state), isA<AccountState>());
      expect(CommandRegistry.isRegistered('OpenAccountCommand'), isTrue);
      expect(StateRegistry.isRegistered('AccountStateV1'), isTrue);
    });

    test('an unknown name still fails clearly', () {
      expect(
        () => EventRegistry.fromMap({'type': 'Nope'}),
        throwsA(isA<ArgumentError>()
            .having((e) => e.message, 'message', contains('Nope'))),
      );
    });

    test('clear() drops aliases as well', () {
      EventRegistry.registerAlias('Old', 'new');
      EventRegistry.clear();
      expect(EventRegistry.resolve('Old'), 'Old');
    });
  });

  group('IsarEventStore records typeName', () {
    late Directory tempDir;
    late IsarEventStore eventStore;

    setUp(() async {
      EventRegistry.register<AccountOpened>(
          'account.opened', AccountOpened.fromMap);
      tempDir = await Directory.systemTemp.createTemp('eventador_typename_');
      await initIsarCoreForTests();
      eventStore = await IsarEventStore.create(
        directory: tempDir.path,
        name: 'typename_${DateTime.now().microsecondsSinceEpoch}',
      );
    });

    tearDown(() async {
      await eventStore.close();
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('the envelope eventType column holds the stable name', () async {
      await eventStore.persistEvent('acct-1', AccountOpened('ann'), 0);

      final envelope = await eventStore.isar.eventEnvelopes.where().findFirst();
      expect(envelope!.eventType, 'account.opened');

      final events = await eventStore.getEvents('acct-1');
      expect(events.single, isA<AccountOpened>());
    });

    test('the snapshot stateType column holds the stable name', () async {
      await eventStore.saveSnapshot('acct-1', AccountState(9), 1);

      final envelope =
          await eventStore.isar.snapshotEnvelopes.where().findFirst();
      expect(envelope!.stateType, 'account.state');

      final snapshot = await eventStore.loadSnapshot('acct-1');
      expect((snapshot!.state as Map)['type'], 'account.state');
      expect((snapshot.state as Map)['balance'], 9);
    });

    test('a non-State snapshot falls back to the class name', () async {
      await eventStore.saveSnapshot('acct-2', {'k': 'v'}, 1);

      final envelope = await eventStore.isar.snapshotEnvelopes
          .where()
          .persistenceIdEqualTo('acct-2')
          .findFirst();
      expect(envelope!.stateType, {'k': 'v'}.runtimeType.toString());
    });
  });
}

class TestOnlyCommand extends Command {
  TestOnlyCommand();
}
