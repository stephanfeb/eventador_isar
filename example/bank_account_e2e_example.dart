/// Complete End-to-End Event Sourcing Example
///
/// This example demonstrates:
/// 1. AggregateRoot (BankAccount) with command and event handling
/// 2. Commands: OpenAccount, DepositMoney, WithdrawMoney
/// 3. Events: AccountOpened, MoneyDeposited, MoneyWithdrawn
/// 4. State management with BankAccountState
/// 5. ProjectionActor with Isar-based read model persistence
/// 6. Complete flow from command to persisted read model
library;

import 'dart:async';
import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:isar_community/isar.dart';

part 'bank_account_e2e_example.g.dart';

// ============================================================================
// 1. DOMAIN MODEL - State
// ============================================================================

/// State for a bank account aggregate
class BankAccountState extends State {
  final String accountId;
  final String accountHolder;
  final double balance;
  final bool isActive;
  final DateTime openedAt;
  final int transactionCount;

  BankAccountState({
    required this.accountId,
    required this.accountHolder,
    required this.balance,
    required this.isActive,
    required this.openedAt,
    required this.transactionCount,
    super.version,
  });

  /// Create initial empty state
  factory BankAccountState.initial(String accountId) {
    return BankAccountState(
      accountId: accountId,
      accountHolder: '',
      balance: 0.0,
      isActive: false,
      openedAt: DateTime.now(),
      transactionCount: 0,
    );
  }

  @override
  BankAccountState copyWith({
    DateTime? lastModified,
    int? version,
  }) {
    return BankAccountState(
      accountId: accountId,
      accountHolder: accountHolder,
      balance: balance,
      isActive: isActive,
      openedAt: openedAt,
      transactionCount: transactionCount,
      version: version ?? this.version,
    );
  }

  /// Custom copy method for updating specific fields
  BankAccountState copyWithFields({
    String? accountId,
    String? accountHolder,
    double? balance,
    bool? isActive,
    DateTime? openedAt,
    int? transactionCount,
    int? version,
  }) {
    return BankAccountState(
      accountId: accountId ?? this.accountId,
      accountHolder: accountHolder ?? this.accountHolder,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      openedAt: openedAt ?? this.openedAt,
      transactionCount: transactionCount ?? this.transactionCount,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'accountHolder': accountHolder,
      'balance': balance,
      'isActive': isActive,
      'openedAt': openedAt.toIso8601String(),
      'transactionCount': transactionCount,
      'version': version,
    };
  }

  factory BankAccountState.fromMap(Map<String, dynamic> map) {
    return BankAccountState(
      accountId: map['accountId'] as String,
      accountHolder: map['accountHolder'] as String,
      balance: (map['balance'] as num).toDouble(),
      isActive: map['isActive'] as bool,
      openedAt: DateTime.parse(map['openedAt'] as String),
      transactionCount: map['transactionCount'] as int,
      version: map['version'] as int? ?? 0,
    );
  }
}

// ============================================================================
// 2. COMMANDS
// ============================================================================

/// Command to open a new bank account
class OpenAccountCommand extends AggregateCommand {
  final String accountHolder;
  final double initialDeposit;

  OpenAccountCommand({
    required String accountId,
    required this.accountHolder,
    required this.initialDeposit,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['accountHolder'] = accountHolder;
    map['initialDeposit'] = initialDeposit;
    return map;
  }
}

/// Command to deposit money into an account
class DepositMoneyCommand extends AggregateCommand {
  final double amount;
  final String description;

  DepositMoneyCommand({
    required String accountId,
    required this.amount,
    this.description = 'Deposit',
    super.expectedVersion,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['amount'] = amount;
    map['description'] = description;
    return map;
  }
}

/// Command to withdraw money from an account
class WithdrawMoneyCommand extends AggregateCommand {
  final double amount;
  final String description;

  WithdrawMoneyCommand({
    required String accountId,
    required this.amount,
    this.description = 'Withdrawal',
    super.expectedVersion,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['amount'] = amount;
    map['description'] = description;
    return map;
  }
}

// ============================================================================
// 3. EVENTS
// ============================================================================

/// Event indicating an account was opened
class AccountOpenedEvent extends AggregateEventBase with SerializableEvent {
  final String accountHolder;
  final double initialDeposit;

  AccountOpenedEvent({
    required String accountId,
    required this.accountHolder,
    required this.initialDeposit,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'accountHolder': accountHolder,
      'initialDeposit': initialDeposit,
    };
  }
}

/// Event indicating money was deposited
class MoneyDepositedEvent extends AggregateEventBase with SerializableEvent {
  final double amount;
  final String description;
  final double newBalance;

  MoneyDepositedEvent({
    required String accountId,
    required this.amount,
    required this.description,
    required this.newBalance,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'amount': amount,
      'description': description,
      'newBalance': newBalance,
    };
  }
}

/// Event indicating money was withdrawn
class MoneyWithdrawnEvent extends AggregateEventBase with SerializableEvent {
  final double amount;
  final String description;
  final double newBalance;

  MoneyWithdrawnEvent({
    required String accountId,
    required this.amount,
    required this.description,
    required this.newBalance,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  Map<String, dynamic> getEventData() {
    return {
      'amount': amount,
      'description': description,
      'newBalance': newBalance,
    };
  }
}

// ============================================================================
// 4. AGGREGATE ROOT
// ============================================================================

/// Bank Account aggregate root
class BankAccountAggregate extends AggregateRoot<BankAccountState> {
  BankAccountAggregate({
    required String accountId,
    required super.eventStore,
  }) : super(
          aggregateId: accountId,
          aggregateType: 'BankAccount',
        );

  @override
  void registerHandlers() {
    // Command handlers will be routed through handleCommand override
    // Event handlers will be routed through applyEvent override
  }

  @override
  Future<List<Event>> handleCommand(
      BankAccountState currentState, Command command) async {
    if (command is OpenAccountCommand) {
      return _handleOpenAccount(currentState, command);
    } else if (command is DepositMoneyCommand) {
      return _handleDepositMoney(currentState, command);
    } else if (command is WithdrawMoneyCommand) {
      return _handleWithdrawMoney(currentState, command);
    }

    return super.handleCommand(currentState, command);
  }

  @override
  BankAccountState applyEvent(BankAccountState currentState, Event event) {
    if (event is AccountOpenedEvent) {
      return _applyAccountOpened(currentState, event);
    } else if (event is MoneyDepositedEvent) {
      return _applyMoneyDeposited(currentState, event);
    } else if (event is MoneyWithdrawnEvent) {
      return _applyMoneyWithdrawn(currentState, event);
    }

    return super.applyEvent(currentState, event);
  }

  @override
  BankAccountState createInitialState() {
    return BankAccountState.initial(aggregateId);
  }

  @override
  Future<BankAccountState> restoreStateFromMap(
    Map<String, dynamic> map,
    int sequenceNumber,
  ) async {
    return BankAccountState.fromMap(map);
  }

  // Command Handlers
  List<Event> _handleOpenAccount(
    BankAccountState state,
    OpenAccountCommand command,
  ) {
    // Business rule: Account must not already be active
    if (state.isActive) {
      throw CommandHandlingException(command, 'Account is already open');
    }

    // Business rule: Initial deposit must be positive
    if (command.initialDeposit < 0) {
      throw CommandHandlingException(
          command, 'Initial deposit must be positive');
    }

    // Generate event
    final event = AccountOpenedEvent(
      accountId: command.aggregateId,
      accountHolder: command.accountHolder,
      initialDeposit: command.initialDeposit,
    );

    return [event];
  }

  List<Event> _handleDepositMoney(
    BankAccountState state,
    DepositMoneyCommand command,
  ) {
    // Business rule: Account must be active
    if (!state.isActive) {
      throw CommandHandlingException(command, 'Account is not active');
    }

    // Business rule: Deposit amount must be positive
    if (command.amount <= 0) {
      throw CommandHandlingException(
          command, 'Deposit amount must be positive');
    }

    // Generate event
    final newBalance = state.balance + command.amount;
    final event = MoneyDepositedEvent(
      accountId: command.aggregateId,
      amount: command.amount,
      description: command.description,
      newBalance: newBalance,
    );

    return [event];
  }

  List<Event> _handleWithdrawMoney(
    BankAccountState state,
    WithdrawMoneyCommand command,
  ) {
    // Business rule: Account must be active
    if (!state.isActive) {
      throw CommandHandlingException(command, 'Account is not active');
    }

    // Business rule: Withdrawal amount must be positive
    if (command.amount <= 0) {
      throw CommandHandlingException(
          command, 'Withdrawal amount must be positive');
    }

    // Business rule: Sufficient funds
    if (state.balance < command.amount) {
      throw CommandHandlingException(
        command,
        'Insufficient funds. Balance: ${state.balance}, Requested: ${command.amount}',
      );
    }

    // Generate event
    final newBalance = state.balance - command.amount;
    final event = MoneyWithdrawnEvent(
      accountId: command.aggregateId,
      amount: command.amount,
      description: command.description,
      newBalance: newBalance,
    );

    return [event];
  }

  // Event Handlers
  BankAccountState _applyAccountOpened(
    BankAccountState state,
    AccountOpenedEvent event,
  ) {
    return state.copyWithFields(
      accountHolder: event.accountHolder,
      balance: event.initialDeposit,
      isActive: true,
      openedAt: event.timestamp,
      transactionCount: 1,
      version: state.version + 1,
    );
  }

  BankAccountState _applyMoneyDeposited(
    BankAccountState state,
    MoneyDepositedEvent event,
  ) {
    return state.copyWithFields(
      balance: event.newBalance,
      transactionCount: state.transactionCount + 1,
      version: state.version + 1,
    );
  }

  BankAccountState _applyMoneyWithdrawn(
    BankAccountState state,
    MoneyWithdrawnEvent event,
  ) {
    return state.copyWithFields(
      balance: event.newBalance,
      transactionCount: state.transactionCount + 1,
      version: state.version + 1,
    );
  }
}

// ============================================================================
// 5. ISAR READ MODEL
// ============================================================================

/// Isar collection for account summary read model
@collection
class AccountSummary {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String accountId;

  late String accountHolder;
  late double balance;
  late bool isActive;
  late DateTime openedAt;
  late int transactionCount;
  late double totalDeposited;
  late double totalWithdrawn;
  late DateTime lastUpdated;

  AccountSummary();

  factory AccountSummary.fromEvent(
    String accountId,
    String accountHolder,
    double initialBalance,
  ) {
    return AccountSummary()
      ..accountId = accountId
      ..accountHolder = accountHolder
      ..balance = initialBalance
      ..isActive = true
      ..openedAt = DateTime.now()
      ..transactionCount = 1
      ..totalDeposited = initialBalance
      ..totalWithdrawn = 0.0
      ..lastUpdated = DateTime.now();
  }
}

// ============================================================================
// 6. PROJECTION WITH ISAR PERSISTENCE
// ============================================================================

/// Projection that builds account summaries from events
class AccountSummaryProjection extends Projection<Map<String, AccountSummary>> {
  final Isar isar;
  final Map<String, AccountSummary> _inMemoryCache = {};

  AccountSummaryProjection({
    required this.isar,
  });

  @override
  String get projectionId => 'account-summary';

  @override
  Map<String, AccountSummary> get readModel => _inMemoryCache;

  @override
  List<Type> get interestedEventTypes => [
        AccountOpenedEvent,
        MoneyDepositedEvent,
        MoneyWithdrawnEvent,
      ];

  @override
  Future<bool> handle(Event event) async {
    try {
      if (event is AccountOpenedEvent) {
        await _handleAccountOpened(event);
        return true;
      } else if (event is MoneyDepositedEvent) {
        await _handleMoneyDeposited(event);
        return true;
      } else if (event is MoneyWithdrawnEvent) {
        await _handleMoneyWithdrawn(event);
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      await onError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> _handleAccountOpened(AccountOpenedEvent event) async {
    final summary = AccountSummary.fromEvent(
      event.aggregateId,
      event.accountHolder,
      event.initialDeposit,
    );

    // Update in-memory cache
    _inMemoryCache[event.aggregateId] = summary;

    // Persist to Isar
    await isar.writeTxn(() async {
      await isar.accountSummarys.put(summary);
    });

    print('📊 Account Summary Created: ${event.aggregateId}');
  }

  Future<void> _handleMoneyDeposited(MoneyDepositedEvent event) async {
    // Get existing summary
    final summary = await _getOrLoadSummary(event.aggregateId);
    if (summary == null) return;

    // Update summary
    summary.balance = event.newBalance;
    summary.transactionCount++;
    summary.totalDeposited += event.amount;
    summary.lastUpdated = DateTime.now();

    // Update in-memory cache
    _inMemoryCache[event.aggregateId] = summary;

    // Persist to Isar
    await isar.writeTxn(() async {
      await isar.accountSummarys.put(summary);
    });

    print(
        '📊 Account Summary Updated (Deposit): ${event.aggregateId}, Balance: ${summary.balance}');
  }

  Future<void> _handleMoneyWithdrawn(MoneyWithdrawnEvent event) async {
    // Get existing summary
    final summary = await _getOrLoadSummary(event.aggregateId);
    if (summary == null) return;

    // Update summary
    summary.balance = event.newBalance;
    summary.transactionCount++;
    summary.totalWithdrawn += event.amount;
    summary.lastUpdated = DateTime.now();

    // Update in-memory cache
    _inMemoryCache[event.aggregateId] = summary;

    // Persist to Isar
    await isar.writeTxn(() async {
      await isar.accountSummarys.put(summary);
    });

    print(
        '📊 Account Summary Updated (Withdrawal): ${event.aggregateId}, Balance: ${summary.balance}');
  }

  Future<AccountSummary?> _getOrLoadSummary(String accountId) async {
    // Try in-memory cache first
    if (_inMemoryCache.containsKey(accountId)) {
      return _inMemoryCache[accountId];
    }

    // Load from Isar
    final summary = await isar.accountSummarys
        .filter()
        .accountIdEqualTo(accountId)
        .findFirst();

    if (summary != null) {
      _inMemoryCache[accountId] = summary;
    }

    return summary;
  }

  /// Query methods for the read model
  Future<AccountSummary?> getAccountSummary(String accountId) async {
    return await _getOrLoadSummary(accountId);
  }

  Future<List<AccountSummary>> getAllAccounts() async {
    return await isar.accountSummarys.where().findAll();
  }

  Future<List<AccountSummary>> getActiveAccounts() async {
    return await isar.accountSummarys.filter().isActiveEqualTo(true).findAll();
  }

  Future<double> getTotalBalanceAllAccounts() async {
    final accounts = await getAllAccounts();
    double total = 0.0;
    for (final account in accounts) {
      total += account.balance;
    }
    return total;
  }

  @override
  Future<void> rebuild() async {
    await reset();
    // In a real implementation, replay all events from EventStore
  }

  @override
  Future<void> reset() async {
    _inMemoryCache.clear();
    await isar.writeTxn(() async {
      await isar.accountSummarys.clear();
    });
  }

  @override
  Future<int> getCheckpoint() async {
    // In a real implementation, load from persistent checkpoint storage
    return 0;
  }

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {
    // In a real implementation, save to persistent checkpoint storage
  }

  @override
  Future<void> onError(dynamic error, StackTrace stackTrace) async {
    print('❌ Projection Error: $error');
    print(stackTrace);
  }
}

// ============================================================================
// 7. MAIN EXAMPLE - COMPLETE E2E FLOW
// ============================================================================

void main() async {
  print('🏦 Bank Account Event Sourcing - Complete E2E Example (Akka-style)\n');

  // Initialize Isar for read models
  final isar = await Isar.open(
    [AccountSummarySchema],
    directory: './',
    name: 'bank_account_e2e',
  );

  // Create EventStore with EventStream support
  final eventStore = MockEventStore();

  // Create projection instance
  final projection = AccountSummaryProjection(isar: isar);

  // Spawn a ProjectionActor - spawning is the registration, as in Pekko.
  // The actor subscribes to the EventStream and drives the projection.
  final actorSystem = LocalActorSystem();
  final projectionRef = await actorSystem.spawn(
    'projection-${projection.projectionId}',
    () => ProjectionActor(projection, eventStore),
  );

  print('✅ ProjectionActor spawned and subscribed to event stream');
  print(
      '   Events will automatically flow: Aggregate → EventStore → Stream → Projection\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 1: Open a bank account');
  print('═══════════════════════════════════════════════════════\n');

  // Create and process aggregate
  final account = BankAccountAggregate(
    accountId: 'account-001',
    eventStore: eventStore,
  );

  account.preStart();
  await Future.delayed(Duration(milliseconds: 50));

  // Execute command - events will be AUTOMATICALLY routed to projection!
  final openCommand = OpenAccountCommand(
    accountId: 'account-001',
    accountHolder: 'John Doe',
    initialDeposit: 1000.0,
  );

  await account.commandHandler(openCommand);

  print('✅ Account opened successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  var summary = await projection.getAccountSummary('account-001');
  print(
      '   Read Model: Balance=\$${summary?.balance}, Holder=${summary?.accountHolder}\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 2: Deposit money');
  print('═══════════════════════════════════════════════════════\n');

  final depositCommand = DepositMoneyCommand(
    accountId: 'account-001',
    amount: 500.0,
    description: 'Salary deposit',
    expectedVersion: 1,
  );

  await account.commandHandler(depositCommand);

  print('✅ Money deposited successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  summary = await projection.getAccountSummary('account-001');
  print(
      '   Read Model: Balance=\$${summary?.balance}, TotalDeposited=\$${summary?.totalDeposited}\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 3: Withdraw money');
  print('═══════════════════════════════════════════════════════\n');

  final withdrawCommand = WithdrawMoneyCommand(
    accountId: 'account-001',
    amount: 200.0,
    description: 'ATM withdrawal',
    expectedVersion: 2,
  );

  await account.commandHandler(withdrawCommand);

  print('✅ Money withdrawn successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  summary = await projection.getAccountSummary('account-001');
  print(
      '   Read Model: Balance=\$${summary?.balance}, TotalWithdrawn=\$${summary?.totalWithdrawn}\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 4: Query read model');
  print('═══════════════════════════════════════════════════════\n');

  final allAccounts = await projection.getAllAccounts();
  print('📊 Total Accounts: ${allAccounts.length}');

  final totalBalance = await projection.getTotalBalanceAllAccounts();
  print(
      '💰 Total Balance Across All Accounts: \$${totalBalance.toStringAsFixed(2)}');

  print('\n═══════════════════════════════════════════════════════');
  print('STEP 5: Demonstrate event sourcing recovery');
  print('═══════════════════════════════════════════════════════\n');

  // Create new aggregate instance (simulates recovery)
  final recoveredAccount = BankAccountAggregate(
    accountId: 'account-001',
    eventStore: eventStore,
  );

  recoveredAccount.preStart();
  await Future.delayed(Duration(milliseconds: 50));

  print('✅ Account recovered from event stream');
  print('   Recovered State: ${recoveredAccount.state?.toMap()}');
  print(
      '   Matches Original: ${recoveredAccount.state?.balance == account.state?.balance}');

  print('\n═══════════════════════════════════════════════════════');
  print('COMPLETE E2E FLOW SUMMARY');
  print('═══════════════════════════════════════════════════════');
  print('✓ Command processing in AggregateRoot');
  print('✓ Event generation and persistence');
  print('✓ Event application to aggregate state');
  print('✓ AUTOMATIC event routing to projection');
  print('✓ Projection event handling');
  print('✓ Read model persistence to Isar');
  print('✓ Read model querying');
  print('✓ Event sourcing recovery\n');

  print(
      '\n🎉 SUCCESS! Akka-style event sourcing architecture working perfectly!');
  print('   No manual event routing needed - everything is automatic!\n');

  // Cleanup
  await projectionRef.ask<StoppedAck>(StopProjection());
  await actorSystem.shutdown();
  await isar.close();
}

// Mock EventStore with EventStream support (Akka-style)
class MockEventStore implements EventStore, EventStream {
  final Map<String, List<Event>> _events = {};
  final Map<String, SnapshotData> _snapshots = {};
  final Map<String, int> _sequences = {};

  /// Global journal: position + 1 is the event's global sequence number.
  final List<Event> _journal = [];
  final StreamController<(Event, int)> _eventStreamController =
      StreamController<(Event, int)>.broadcast();

  void _append(Event event) {
    _journal.add(event);
    _eventStreamController.add((event, _journal.length));
  }

  @override
  Future<void> persistEvent(
      String persistenceId, Event event, int expectedVersion) async {
    final currentSequence = _sequences[persistenceId] ?? 0;
    if (currentSequence != expectedVersion) {
      throw Exception('Optimistic concurrency violation');
    }

    _events.putIfAbsent(persistenceId, () => []);
    _events[persistenceId]!.add(event);
    _sequences[persistenceId] = currentSequence + 1;

    // Emit event to stream (Akka-style streaming)
    _append(event);
  }

  @override
  Future<void> persistEvents(
      String persistenceId, List<Event> events, int expectedVersion) async {
    final currentSequence = _sequences[persistenceId] ?? 0;
    if (currentSequence != expectedVersion) {
      throw Exception('Optimistic concurrency violation');
    }

    _events.putIfAbsent(persistenceId, () => []);
    _events[persistenceId]!.addAll(events);
    _sequences[persistenceId] = currentSequence + events.length;

    // Emit events to stream (Akka-style streaming)
    for (final event in events) {
      _append(event);
    }
  }

  @override
  Future<List<Event>> getEvents(String persistenceId,
      {int fromSequence = 0, int? toSequence}) async {
    final events = _events[persistenceId] ?? [];
    final startIndex = fromSequence;
    final endIndex = toSequence ?? events.length;

    if (startIndex >= events.length) {
      return [];
    }

    return events.sublist(
        startIndex, endIndex.clamp(startIndex, events.length));
  }

  @override
  Future<int> getHighestSequenceNumber(String persistenceId) async {
    return _sequences[persistenceId] ?? 0;
  }

  @override
  Future<void> saveSnapshot(
      String persistenceId, dynamic state, int sequenceNumber) async {
    _snapshots[persistenceId] = SnapshotData(
      state: state,
      sequenceNumber: sequenceNumber,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<SnapshotData?> loadSnapshot(String persistenceId) async {
    return _snapshots[persistenceId];
  }

  @override
  Future<void> deleteOldSnapshots(String persistenceId, int keepCount) async {
    // Mock implementation
  }

  @override
  Future<void> close() async {
    await _eventStreamController.close();
  }

  // ============================================================================
  // EventStream Implementation (Akka Persistence Query)
  // ============================================================================

  @override
  Stream<Event> allEvents({
    int fromSequence = 0,
    bool live = true,
  }) {
    return allEventsWithSequence(fromSequence: fromSequence, live: live)
        .map((record) => record.$1);
  }

  @override
  Stream<Event> eventsByTag(
    String tag, {
    int fromSequence = 0,
    bool live = true,
  }) async* {
    await for (final event
        in allEvents(fromSequence: fromSequence, live: live)) {
      if (event is EventTags && event.tags.contains(tag)) {
        yield event;
      }
    }
  }

  @override
  Stream<Event> eventsByPersistenceId(
    String persistenceId, {
    int fromSequence = 0,
    bool live = true,
  }) {
    // Mock: filters the global stream; the per-actor fromSequence is not
    // modelled here.
    return allEvents(live: live)
        .where((event) => _events[persistenceId]?.contains(event) ?? false);
  }

  @override
  Stream<String> currentPersistenceIds() async* {
    for (final id in _events.keys) {
      yield id;
    }
  }

  @override
  Stream<(Event, int)> allEventsWithSequence(
      {int fromSequence = 0, bool live = true}) {
    // Replay the journal after [fromSequence], then continue live. The live
    // subscription is taken before the replay so nothing appended meanwhile
    // is skipped, and it is cancelled through onCancel so a subscriber can
    // stop promptly (an async* generator parked in `await for` cannot).
    late final StreamController<(Event, int)> controller;
    StreamSubscription<(Event, int)>? liveSub;
    controller = StreamController<(Event, int)>(
      onListen: () {
        var last = fromSequence;
        var replaying = true;
        final pending = <(Event, int)>[];
        void emit((Event, int) record) {
          if (record.$2 > last && !controller.isClosed) {
            last = record.$2;
            controller.add(record);
          }
        }

        if (live) {
          liveSub = _eventStreamController.stream.listen(
              (record) => replaying ? pending.add(record) : emit(record));
        }
        for (var i = fromSequence; i < _journal.length; i++) {
          emit((_journal[i], i + 1));
        }
        replaying = false;
        pending.forEach(emit);
        if (!live) controller.close();
      },
      onCancel: () async {
        await liveSub?.cancel();
      },
    );
    return controller.stream;
  }
}

/// Step-by-step variant of [main]; call it instead of `main` to walk through
/// the scenario with printed commentary.
void manualExample() async {
  print('🏦 Bank Account Event Sourcing - Complete E2E Example\n');

  // Initialize Isar
  final isar = await Isar.open(
    [AccountSummarySchema],
    directory: './',
    name: 'bank_account_e2e',
  );

  // Create event store
  final eventStore = MockEventStore();

  // Create projection
  final projection = AccountSummaryProjection(isar: isar);

  print('═══════════════════════════════════════════════════════');
  print('STEP 1: Open a bank account');
  print('═══════════════════════════════════════════════════════\n');

  // Create and process aggregate
  final account = BankAccountAggregate(
    accountId: 'account-001',
    eventStore: eventStore,
  );

  account.preStart();
  await Future.delayed(Duration(milliseconds: 50));

  // Execute command
  final openCommand = OpenAccountCommand(
    accountId: 'account-001',
    accountHolder: 'John Doe',
    initialDeposit: 1000.0,
  );

  await account.commandHandler(openCommand);

  // Manually route event to projection (in real system, ProjectionActor does this)
  final openedEvent = await eventStore.getEvents('BankAccount_account-001');
  for (final event in openedEvent) {
    await projection.handle(event);
  }

  print('✅ Account opened successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  var summary = await projection.getAccountSummary('account-001');
  print('   Read Model: $summary\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 2: Deposit money');
  print('═══════════════════════════════════════════════════════\n');

  final depositCommand = DepositMoneyCommand(
    accountId: 'account-001',
    amount: 500.0,
    description: 'Salary deposit',
    expectedVersion: 1,
  );

  await account.commandHandler(depositCommand);

  // Route new events to projection
  final depositEvents =
      await eventStore.getEvents('BankAccount_account-001', fromSequence: 1);
  for (final event in depositEvents) {
    await projection.handle(event);
  }

  print('✅ Money deposited successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  summary = await projection.getAccountSummary('account-001');
  print(
      '   Read Model: Balance=${summary?.balance}, TotalDeposited=${summary?.totalDeposited}\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 3: Withdraw money');
  print('═══════════════════════════════════════════════════════\n');

  final withdrawCommand = WithdrawMoneyCommand(
    accountId: 'account-001',
    amount: 200.0,
    description: 'ATM withdrawal',
    expectedVersion: 2,
  );

  await account.commandHandler(withdrawCommand);

  // Route new events to projection
  final withdrawEvents =
      await eventStore.getEvents('BankAccount_account-001', fromSequence: 2);
  for (final event in withdrawEvents) {
    await projection.handle(event);
  }

  print('✅ Money withdrawn successfully');
  print('   Aggregate State: ${account.state?.toMap()}');

  summary = await projection.getAccountSummary('account-001');
  print(
      '   Read Model: Balance=${summary?.balance}, TotalWithdrawn=${summary?.totalWithdrawn}\n');

  print('═══════════════════════════════════════════════════════');
  print('STEP 4: Query read model');
  print('═══════════════════════════════════════════════════════\n');

  final allAccounts = await projection.getAllAccounts();
  print('📊 Total Accounts: ${allAccounts.length}');

  final totalBalance = await projection.getTotalBalanceAllAccounts();
  print(
      '💰 Total Balance Across All Accounts: \$${totalBalance.toStringAsFixed(2)}');

  print('\n═══════════════════════════════════════════════════════');
  print('STEP 5: Demonstrate event sourcing recovery');
  print('═══════════════════════════════════════════════════════\n');

  // Create new aggregate instance (simulates recovery)
  final recoveredAccount = BankAccountAggregate(
    accountId: 'account-001',
    eventStore: eventStore,
  );

  recoveredAccount.preStart();
  await Future.delayed(Duration(milliseconds: 50));

  print('✅ Account recovered from event stream');
  print('   Recovered State: ${recoveredAccount.state?.toMap()}');
  print(
      '   Matches Original: ${recoveredAccount.state?.balance == account.state?.balance}');

  print('\n═══════════════════════════════════════════════════════');
  print('COMPLETE E2E FLOW SUMMARY');
  print('═══════════════════════════════════════════════════════');
  print('✓ Command processing in AggregateRoot');
  print('✓ Event generation and persistence');
  print('✓ Event application to aggregate state');
  print('✓ Projection event handling');
  print('✓ Read model persistence to Isar');
  print('✓ Read model querying');
  print('✓ Event sourcing recovery\n');

  // Cleanup
  await isar.close();
}
