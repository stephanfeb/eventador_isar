// Concurrency Bug Reproduction Tests
// Tests that reproduce the bug described in EVENTADOR_CONCURRENCY_BUG.md
// Using real actor system with tell() to simulate production scenario

import 'dart:io';
import 'package:test/test.dart';

import 'support/isar_core.dart';
import 'package:isar_community/isar.dart';
import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';

void main() {
  group('Aggregate Concurrency Bug - Actor System Tests', () {
    late Isar isar;
    late EventStore eventStore;
    late Directory tempDir;
    late ActorSystem actorSystem;

    setUpAll(() async {
      // Create temporary directory for test database
      tempDir =
          await Directory.systemTemp.createTemp('eventador_concurrency_test_');
    });

    setUp(() async {
      // Initialize Isar database for each test
      await initIsarCoreForTests();
      isar = await Isar.open(
        [EventEnvelopeSchema, SnapshotEnvelopeSchema],
        directory: tempDir.path,
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      eventStore = IsarEventStore(isar);

      // Initialize actor system
      actorSystem = LocalActorSystem();

      // Register event types for deserialization
      EventRegistry.clear();
      EventRegistry.register<AccountCreatedEvent>(
        'AccountCreatedEvent',
        AccountCreatedEvent.fromMap,
      );
      EventRegistry.register<MoneyDepositedEvent>(
        'MoneyDepositedEvent',
        MoneyDepositedEvent.fromMap,
      );
      EventRegistry.register<MoneyWithdrawnEvent>(
        'MoneyWithdrawnEvent',
        MoneyWithdrawnEvent.fromMap,
      );
    });

    tearDown(() async {
      await actorSystem.shutdown();
      await isar.close();
    });

    tearDownAll(() async {
      // Clean up temporary directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should handle rapid tell() commands without concurrency exceptions',
        () async {
      // Spawn the aggregate as an actor
      final accountRef = await actorSystem.spawn(
        'bank-account-123',
        () => TestBankAccount(
          aggregateId: 'account-123',
          eventStore: eventStore,
        ),
      );

      // Wait for recovery
      await Future.delayed(Duration(milliseconds: 150));

      // Create account
      accountRef.tell(CreateAccountCommand(
        aggregateId: 'account-123',
        accountHolderName: 'John Doe',
        initialBalance: 100.0,
      ));

      // Wait for account creation to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Send 10 rapid deposits via tell() - no await, fire-and-forget
      // This simulates the real-world bug scenario
      for (int i = 0; i < 10; i++) {
        accountRef.tell(DepositCommand(
          aggregateId: 'account-123',
          amount: 100.0,
        ));
        // NO DELAY - this is the key to reproducing the bug
      }

      // Wait for all commands to process
      await Future.delayed(Duration(milliseconds: 500));

      // Query the final state by loading events from the event store
      final events = await eventStore.getEvents('BankAccount_account-123');

      // Should have 11 events total (1 create + 10 deposits)
      expect(events.length, equals(11),
          reason:
              'Should have 11 events if no concurrency exceptions occurred');

      // Verify the events are in sequence
      for (int i = 0; i < events.length; i++) {
        expect(events[i].version, equals(i + 1),
            reason: 'Event $i should have version ${i + 1}');
      }

      // Verify final balance by replaying events
      final account = TestBankAccount(
        aggregateId: 'account-123',
        eventStore: eventStore,
      );
      account.replay(events);

      expect(account.currentState.balance, equals(1100.0));
      expect(account.currentState.version, equals(11));
    });

    test('should handle 30 rapid tell() commands with mixed operations',
        () async {
      // Spawn the aggregate as an actor
      final accountRef = await actorSystem.spawn(
        'bank-account-456',
        () => TestBankAccount(
          aggregateId: 'account-456',
          eventStore: eventStore,
        ),
      );

      // Wait for recovery
      await Future.delayed(Duration(milliseconds: 150));

      // Create account with sufficient balance
      accountRef.tell(CreateAccountCommand(
        aggregateId: 'account-456',
        accountHolderName: 'Jane Smith',
        initialBalance: 2000.0,
      ));

      // Wait for account creation
      await Future.delayed(Duration(milliseconds: 100));

      // Send 30 rapid commands via tell() - alternating deposits and withdrawals
      for (int i = 0; i < 30; i++) {
        if (i % 2 == 0) {
          accountRef.tell(DepositCommand(
            aggregateId: 'account-456',
            amount: 50.0,
          ));
        } else {
          accountRef.tell(WithdrawCommand(
            aggregateId: 'account-456',
            amount: 25.0,
          ));
        }
      }

      // Wait for all commands to process
      await Future.delayed(Duration(milliseconds: 800));

      // Query the final state
      final events = await eventStore.getEvents('BankAccount_account-456');

      // Should have 31 events total (1 create + 30 operations)
      expect(events.length, equals(31),
          reason:
              'Should have 31 events if no concurrency exceptions occurred');

      // Verify the events are in sequence
      for (int i = 0; i < events.length; i++) {
        expect(events[i].version, equals(i + 1),
            reason: 'Event $i should have version ${i + 1}');
      }

      // Verify final balance: 2000 + (15 * 50) - (15 * 25) = 2375
      final account = TestBankAccount(
        aggregateId: 'account-456',
        eventStore: eventStore,
      );
      account.replay(events);

      final expectedBalance = 2000.0 + (15 * 50.0) - (15 * 25.0);
      expect(account.currentState.balance, equals(expectedBalance));
      expect(account.currentState.version, equals(31));
    });

    test('stress test - 100 rapid commands', () async {
      // This is a more aggressive test to try to expose any concurrency issues
      final accountRef = await actorSystem.spawn(
        'bank-account-stress',
        () => TestBankAccount(
          aggregateId: 'account-stress',
          eventStore: eventStore,
        ),
      );

      await Future.delayed(Duration(milliseconds: 150));

      // Create account
      accountRef.tell(CreateAccountCommand(
        aggregateId: 'account-stress',
        accountHolderName: 'Stress Test',
        initialBalance: 10000.0,
      ));

      await Future.delayed(Duration(milliseconds: 100));

      // Send 100 rapid commands with absolutely no delays
      for (int i = 0; i < 100; i++) {
        accountRef.tell(DepositCommand(
          aggregateId: 'account-stress',
          amount: 10.0,
        ));
      }

      // Wait longer for all to process
      await Future.delayed(Duration(milliseconds: 1500));

      // Verify
      final events = await eventStore.getEvents('BankAccount_account-stress');

      print('Stress test: Expected 101 events, got ${events.length}');

      expect(events.length, equals(101),
          reason: 'Should have 101 events (1 create + 100 deposits)');

      // Verify sequence
      for (int i = 0; i < events.length; i++) {
        expect(events[i].version, equals(i + 1),
            reason:
                'Event $i should have version ${i + 1}, but has ${events[i].version}');
      }

      final account = TestBankAccount(
        aggregateId: 'account-stress',
        eventStore: eventStore,
      );
      account.replay(events);

      expect(account.currentState.balance, equals(11000.0));
      expect(account.currentState.version, equals(101));
    });

    test('multiple actors should not interfere with each other', () async {
      // Spawn three separate aggregate actors
      final account1 = await actorSystem.spawn(
        'bank-account-001',
        () => TestBankAccount(
          aggregateId: 'account-001',
          eventStore: eventStore,
        ),
      );

      final account2 = await actorSystem.spawn(
        'bank-account-002',
        () => TestBankAccount(
          aggregateId: 'account-002',
          eventStore: eventStore,
        ),
      );

      final account3 = await actorSystem.spawn(
        'bank-account-003',
        () => TestBankAccount(
          aggregateId: 'account-003',
          eventStore: eventStore,
        ),
      );

      // Wait for recovery
      await Future.delayed(Duration(milliseconds: 150));

      // Create all accounts
      account1.tell(CreateAccountCommand(
        aggregateId: 'account-001',
        accountHolderName: 'User 1',
        initialBalance: 1000.0,
      ));
      account2.tell(CreateAccountCommand(
        aggregateId: 'account-002',
        accountHolderName: 'User 2',
        initialBalance: 2000.0,
      ));
      account3.tell(CreateAccountCommand(
        aggregateId: 'account-003',
        accountHolderName: 'User 3',
        initialBalance: 3000.0,
      ));

      await Future.delayed(Duration(milliseconds: 100));

      // Send rapid commands to all three accounts simultaneously
      for (int i = 0; i < 10; i++) {
        account1.tell(DepositCommand(aggregateId: 'account-001', amount: 10.0));
        account2.tell(DepositCommand(aggregateId: 'account-002', amount: 20.0));
        account3.tell(DepositCommand(aggregateId: 'account-003', amount: 30.0));
      }

      // Wait for all commands to process
      await Future.delayed(Duration(milliseconds: 500));

      // Verify each account independently
      final events1 = await eventStore.getEvents('BankAccount_account-001');
      final events2 = await eventStore.getEvents('BankAccount_account-002');
      final events3 = await eventStore.getEvents('BankAccount_account-003');

      expect(events1.length, equals(11));
      expect(events2.length, equals(11));
      expect(events3.length, equals(11));

      // Verify final balances
      final acc1 =
          TestBankAccount(aggregateId: 'account-001', eventStore: eventStore);
      acc1.replay(events1);
      expect(acc1.currentState.balance, equals(1100.0));

      final acc2 =
          TestBankAccount(aggregateId: 'account-002', eventStore: eventStore);
      acc2.replay(events2);
      expect(acc2.currentState.balance, equals(2200.0));

      final acc3 =
          TestBankAccount(aggregateId: 'account-003', eventStore: eventStore);
      acc3.replay(events3);
      expect(acc3.currentState.balance, equals(3300.0));
    });
  });
}

// Reuse test implementations from aggregate_root_test.dart

class BankAccountState extends State
    with ValidatableState, SerializableState, SnapshotableState {
  final String accountHolderName;
  final double balance;
  final bool isActive;

  BankAccountState({
    required this.accountHolderName,
    required this.balance,
    this.isActive = true,
    super.version,
    super.lastModified,
  });

  @override
  BankAccountState copyWith({
    String? accountHolderName,
    double? balance,
    bool? isActive,
    int? version,
    DateTime? lastModified,
  }) {
    return BankAccountState(
      accountHolderName: accountHolderName ?? this.accountHolderName,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, dynamic> getStateData() {
    return {
      'accountHolderName': accountHolderName,
      'balance': balance,
      'isActive': isActive,
    };
  }

  static BankAccountState fromMap(Map<String, dynamic> map) {
    return BankAccountState(
      accountHolderName: map['accountHolderName'] as String,
      balance: (map['balance'] as num).toDouble(),
      isActive: map['isActive'] as bool? ?? true,
      version: map['version'] as int? ?? 0,
      lastModified: map['lastModified'] != null
          ? (map['lastModified'] is String
              ? DateTime.parse(map['lastModified'] as String)
              : map['lastModified'] as DateTime)
          : null,
    );
  }

  @override
  BankAccountState restoreFromSnapshot(Map<String, dynamic> snapshot) {
    return fromMap(snapshot);
  }

  @override
  List<String> getCustomValidationErrors() {
    final errors = <String>[];
    if (accountHolderName.isEmpty) {
      errors.add('Account holder name cannot be empty');
    }
    if (balance < 0) {
      errors.add('Account balance cannot be negative');
    }
    return errors;
  }
}

// Commands
class CreateAccountCommand extends AggregateCommand with ValidatableCommand {
  final String accountHolderName;
  final double initialBalance;

  CreateAccountCommand({
    required super.aggregateId,
    required this.accountHolderName,
    required this.initialBalance,
    super.expectedVersion,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'accountHolderName': accountHolderName,
      'initialBalance': initialBalance,
    });
    return map;
  }

  @override
  List<String> getCustomValidationErrors() {
    final errors = <String>[];
    if (accountHolderName.isEmpty) {
      errors.add('Account holder name cannot be empty');
    }
    if (initialBalance < 0) {
      errors.add('Initial balance cannot be negative');
    }
    return errors;
  }
}

class DepositCommand extends AggregateCommand with ValidatableCommand {
  final double amount;

  DepositCommand({
    required super.aggregateId,
    required this.amount,
    super.expectedVersion,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['amount'] = amount;
    return map;
  }

  @override
  List<String> getCustomValidationErrors() {
    final errors = <String>[];
    if (amount <= 0) {
      errors.add('Deposit amount must be positive');
    }
    return errors;
  }
}

class WithdrawCommand extends AggregateCommand with ValidatableCommand {
  final double amount;

  WithdrawCommand({
    required super.aggregateId,
    required this.amount,
    super.expectedVersion,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['amount'] = amount;
    return map;
  }

  @override
  List<String> getCustomValidationErrors() {
    final errors = <String>[];
    if (amount <= 0) {
      errors.add('Withdrawal amount must be positive');
    }
    return errors;
  }
}

// Events
class AccountCreatedEvent extends AggregateEventBase with SerializableEvent {
  final String accountHolderName;
  final double initialBalance;

  AccountCreatedEvent({
    required super.aggregateId,
    required this.accountHolderName,
    required this.initialBalance,
    super.eventId,
    super.timestamp,
    super.version,
    super.metadata,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'accountHolderName': accountHolderName,
      'initialBalance': initialBalance,
    };
  }

  static AccountCreatedEvent fromMap(Map<String, dynamic> map) {
    return AccountCreatedEvent(
      aggregateId: map['aggregateId'] as String,
      accountHolderName: map['accountHolderName'] as String,
      initialBalance: (map['initialBalance'] as num).toDouble(),
      eventId: map['eventId'] as String?,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is String
              ? DateTime.parse(map['timestamp'] as String)
              : map['timestamp'] as DateTime)
          : null,
      version: map['version'] as int?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
}

class MoneyDepositedEvent extends AggregateEventBase with SerializableEvent {
  final double amount;
  final double newBalance;

  MoneyDepositedEvent({
    required super.aggregateId,
    required this.amount,
    required this.newBalance,
    super.eventId,
    super.timestamp,
    super.version,
    super.metadata,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'amount': amount,
      'newBalance': newBalance,
    };
  }

  static MoneyDepositedEvent fromMap(Map<String, dynamic> map) {
    return MoneyDepositedEvent(
      aggregateId: map['aggregateId'] as String,
      amount: (map['amount'] as num).toDouble(),
      newBalance: (map['newBalance'] as num).toDouble(),
      eventId: map['eventId'] as String?,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is String
              ? DateTime.parse(map['timestamp'] as String)
              : map['timestamp'] as DateTime)
          : null,
      version: map['version'] as int?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
}

class MoneyWithdrawnEvent extends AggregateEventBase with SerializableEvent {
  final double amount;
  final double newBalance;

  MoneyWithdrawnEvent({
    required super.aggregateId,
    required this.amount,
    required this.newBalance,
    super.eventId,
    super.timestamp,
    super.version,
    super.metadata,
  }) : super(
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'amount': amount,
      'newBalance': newBalance,
    };
  }

  static MoneyWithdrawnEvent fromMap(Map<String, dynamic> map) {
    return MoneyWithdrawnEvent(
      aggregateId: map['aggregateId'] as String,
      amount: (map['amount'] as num).toDouble(),
      newBalance: (map['newBalance'] as num).toDouble(),
      eventId: map['eventId'] as String?,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is String
              ? DateTime.parse(map['timestamp'] as String)
              : map['timestamp'] as DateTime)
          : null,
      version: map['version'] as int?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
}

// Command Handlers
class CreateAccountCommandHandler
    extends AggregateCommandHandler<BankAccountState> {
  @override
  String get aggregateId => '';

  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canHandle(Command command) {
    return command is CreateAccountCommand;
  }

  @override
  List<Event> handle(BankAccountState currentState, Command command) {
    final createCommand = command as CreateAccountCommand;

    return [
      AccountCreatedEvent(
        aggregateId: createCommand.aggregateId,
        accountHolderName: createCommand.accountHolderName,
        initialBalance: createCommand.initialBalance,
        version: currentState.version + 1,
      ),
    ];
  }
}

class DepositCommandHandler extends AggregateCommandHandler<BankAccountState> {
  @override
  String get aggregateId => '';

  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canHandle(Command command) {
    return command is DepositCommand;
  }

  @override
  List<Event> handle(BankAccountState currentState, Command command) {
    final depositCommand = command as DepositCommand;
    final newBalance = currentState.balance + depositCommand.amount;

    return [
      MoneyDepositedEvent(
        aggregateId: depositCommand.aggregateId,
        amount: depositCommand.amount,
        newBalance: newBalance,
        version: currentState.version + 1,
      ),
    ];
  }
}

class WithdrawCommandHandler extends AggregateCommandHandler<BankAccountState> {
  @override
  String get aggregateId => '';

  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canHandle(Command command) {
    return command is WithdrawCommand;
  }

  @override
  List<Event> handle(BankAccountState currentState, Command command) {
    final withdrawCommand = command as WithdrawCommand;

    // Business rule: Cannot withdraw more than current balance
    if (withdrawCommand.amount > currentState.balance) {
      throw CommandHandlingException(
        command,
        'Insufficient funds: cannot withdraw ${withdrawCommand.amount}, balance is ${currentState.balance}',
      );
    }

    final newBalance = currentState.balance - withdrawCommand.amount;

    return [
      MoneyWithdrawnEvent(
        aggregateId: withdrawCommand.aggregateId,
        amount: withdrawCommand.amount,
        newBalance: newBalance,
        version: currentState.version + 1,
      ),
    ];
  }
}

// Event Handlers
class AccountCreatedEventHandler
    extends AggregateEventHandler<BankAccountState> {
  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canApply(Event event) {
    return event is AccountCreatedEvent;
  }

  @override
  BankAccountState apply(BankAccountState currentState, Event event) {
    final createdEvent = event as AccountCreatedEvent;

    return BankAccountState(
      accountHolderName: createdEvent.accountHolderName,
      balance: createdEvent.initialBalance,
      version: createdEvent.version,
      lastModified: createdEvent.timestamp,
    );
  }
}

class MoneyDepositedEventHandler
    extends AggregateEventHandler<BankAccountState> {
  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canApply(Event event) {
    return event is MoneyDepositedEvent;
  }

  @override
  BankAccountState apply(BankAccountState currentState, Event event) {
    final depositedEvent = event as MoneyDepositedEvent;

    return currentState.copyWith(
      balance: depositedEvent.newBalance,
      version: depositedEvent.version,
      lastModified: depositedEvent.timestamp,
    );
  }
}

class MoneyWithdrawnEventHandler
    extends AggregateEventHandler<BankAccountState> {
  @override
  String get aggregateType => 'BankAccount';

  @override
  bool canApply(Event event) {
    return event is MoneyWithdrawnEvent;
  }

  @override
  BankAccountState apply(BankAccountState currentState, Event event) {
    final withdrawnEvent = event as MoneyWithdrawnEvent;

    return currentState.copyWith(
      balance: withdrawnEvent.newBalance,
      version: withdrawnEvent.version,
      lastModified: withdrawnEvent.timestamp,
    );
  }
}

// Test BankAccount Aggregate
class TestBankAccount extends AggregateRoot<BankAccountState> {
  TestBankAccount({
    required super.aggregateId,
    required super.eventStore,
  }) : super(
          aggregateType: 'BankAccount',
        ) {
    // Register handlers immediately upon construction
    registerHandlers();
  }

  @override
  void registerHandlers() {
    // Register command handlers
    commandHandlers
        .register<CreateAccountCommand>(CreateAccountCommandHandler());
    commandHandlers.register<DepositCommand>(DepositCommandHandler());
    commandHandlers.register<WithdrawCommand>(WithdrawCommandHandler());

    // Register event handlers
    eventHandlers.register<AccountCreatedEvent>(AccountCreatedEventHandler());
    eventHandlers.register<MoneyDepositedEvent>(MoneyDepositedEventHandler());
    eventHandlers.register<MoneyWithdrawnEvent>(MoneyWithdrawnEventHandler());
  }

  @override
  BankAccountState createInitialState() {
    return BankAccountState(
      accountHolderName: '',
      balance: 0.0,
      version: 0,
    );
  }

  @override
  Future<BankAccountState> restoreStateFromMap(
      Map<String, dynamic> map, int sequenceNumber) async {
    return BankAccountState.fromMap(map);
  }
}
