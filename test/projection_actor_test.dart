import 'dart:async';
import 'dart:io';

import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

/// Test event.
class TickEvent extends Event {
  final int n;
  TickEvent(this.n) : super();

  Map<String, dynamic> getEventData() => {'n': n};
}

/// Test event of a different type (used to verify type filtering).
class NoiseEvent extends Event {
  NoiseEvent() : super();
}

/// In-memory event stream test double. Supports manual emission of
/// `(Event, int)` records for `allEventsWithSequence`.
class InMemoryEventStream implements EventStream {
  final StreamController<(Event, int)> _controller =
      StreamController<(Event, int)>.broadcast();

  void emit(Event event, int envelopeId) {
    _controller.add((event, envelopeId));
  }

  void emitError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  Future<void> close() => _controller.close();

  @override
  Stream<(Event, int)> allEventsWithSequence({
    int fromSequence = 0,
    bool live = true,
  }) {
    return _controller.stream.where((record) => record.$2 > fromSequence);
  }

  @override
  Stream<Event> allEvents({int fromSequence = 0, bool live = true}) {
    return allEventsWithSequence(fromSequence: fromSequence, live: live)
        .map((r) => r.$1);
  }

  @override
  Stream<Event> eventsByTag(String tag,
          {int fromSequence = 0, bool live = true}) =>
      allEvents(fromSequence: fromSequence, live: live);

  @override
  Stream<Event> eventsByPersistenceId(String persistenceId,
          {int fromSequence = 0, bool live = true}) =>
      allEvents(fromSequence: fromSequence, live: live);

  @override
  Stream<String> currentPersistenceIds() => const Stream.empty();
}

/// Configurable test projection.
///
/// - `handleHook` runs inside `handle` (after the order log is recorded) so
///   tests can inject delays or force exceptions.
/// - `failOn(n)` makes `handle` throw for `TickEvent(n)` specifically.
class TestProjection extends Projection<List<int>> {
  final String _id;
  final List<int> _received = [];
  final Future<void> Function(Event event)? handleHook;
  final Set<int> failOn;
  int resetCalls = 0;
  int startCalls = 0;
  int stopCalls = 0;
  int errorCalls = 0;

  TestProjection(
    this._id, {
    this.handleHook,
    Set<int>? failOn,
  }) : failOn = failOn ?? <int>{};

  @override
  String get projectionId => _id;

  @override
  List<int> get readModel => List.unmodifiable(_received);

  @override
  List<Type> get interestedEventTypes => [TickEvent];

  @override
  Future<bool> handle(Event event) async {
    if (event is! TickEvent) return false;
    _received.add(event.n);
    if (handleHook != null) {
      await handleHook!(event);
    }
    if (failOn.contains(event.n)) {
      throw StateError('forced failure on tick ${event.n}');
    }
    return true;
  }

  @override
  Future<void> rebuild() async {
    await reset();
  }

  @override
  Future<void> reset() async {
    resetCalls++;
    _received.clear();
  }

  @override
  Future<int> getCheckpoint() async => 0;

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {}

  @override
  Future<void> onStart() async {
    startCalls++;
  }

  @override
  Future<void> onStop() async {
    stopCalls++;
  }

  @override
  Future<void> onError(dynamic error, StackTrace stackTrace) async {
    errorCalls++;
  }
}

/// Wait until a condition is true or a timeout elapses.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 2),
  Duration interval = const Duration(milliseconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (condition()) return;
    await Future<void>.delayed(interval);
  }
  fail('waitFor timed out');
}

/// ProjectionActor whose checkpoint read fails a configurable number of
/// times before delegating to the real implementation.
class FlakyCheckpointActor extends ProjectionActor<List<int>> {
  int failuresLeft;
  int loadAttempts = 0;

  FlakyCheckpointActor(
    super.projection,
    super.eventStream, {
    required this.failuresLeft,
    super.checkpoints,
    super.checkpointBatchSize,
  });

  @override
  Future<int> loadCheckpoint() async {
    loadAttempts++;
    if (failuresLeft > 0) {
      failuresLeft--;
      throw StateError('checkpoint store unavailable');
    }
    return super.loadCheckpoint();
  }
}

void main() {
  group('ProjectionActor', () {
    late ActorSystem system;
    late InMemoryEventStream stream;

    setUp(() async {
      system = ActorSystem.create();
      stream = InMemoryEventStream();
    });

    tearDown(() async {
      await stream.close();
      await system.shutdown();
    });

    Future<ActorRef> spawnActor(
      Projection projection, {
      int batchSize = 100,
    }) {
      return system.spawn(
        'projection-${projection.projectionId}',
        () =>
            ProjectionActor(projection, stream, checkpointBatchSize: batchSize),
      );
    }

    test('processes events sequentially in order', () async {
      final p = TestProjection('p1');
      await spawnActor(p);

      for (var i = 1; i <= 20; i++) {
        stream.emit(TickEvent(i), i);
      }

      await waitFor(() => p.readModel.length == 20);
      expect(p.readModel, equals(List.generate(20, (i) => i + 1)));
    });

    test('AwaitEventApplied resolves after matching handle() completes',
        () async {
      // Inject a delay inside handle so we can prove resolution happens AFTER
      // handle() returns, not when the event arrives at the mailbox.
      final handleCompleted = <int>{};
      final p = TestProjection(
        'p2',
        handleHook: (event) async {
          await Future<void>.delayed(const Duration(milliseconds: 30));
          if (event is TickEvent) handleCompleted.add(event.n);
        },
      );
      final ref = await spawnActor(p);

      final future = ref.ask<EventAppliedResponse>(
        AwaitEventApplied(
          (e) => e is TickEvent && e.n == 7,
          timeout: const Duration(seconds: 2),
        ),
      );

      // Emit a few events; only TickEvent(7) should resolve the awaiter.
      for (var i = 1; i <= 10; i++) {
        stream.emit(TickEvent(i), i);
      }

      final resp = await future;
      expect(resp.matchedEvent, isA<TickEvent>());
      expect((resp.matchedEvent as TickEvent).n, equals(7));
      // handle() for event 7 must have completed before the reply arrived.
      expect(handleCompleted.contains(7), isTrue);
    });

    test('alreadySatisfied short-circuits without queueing', () async {
      final p = TestProjection('p3');
      final ref = await spawnActor(p);

      final resp = await ref.ask<EventAppliedResponse>(
        AwaitEventApplied(
          (_) => false, // would never match
          alreadySatisfied: () => true,
        ),
      );
      expect(resp.matchedEvent, isNull);
    });

    test('CancelEventAwait releases a pending registration at once', () async {
      final p = TestProjection('p4-cancel');
      final ref = await spawnActor(p);

      // A 30 s window: without the cancel this ask cannot complete inside the
      // test, which is the whole point — a caller whose command was rejected
      // used to hold the registration until the window expired.
      final pending = ref.ask<AwaitFailed>(
        AwaitEventApplied(
          (_) => false,
          timeout: const Duration(seconds: 30),
          awaitId: 'open-channel-1',
        ),
      );

      final ack = await ref.ask<EventAwaitCancelled>(
        CancelEventAwait('open-channel-1'),
      );
      expect(ack.cancelled, equals(1));

      final result = await pending.timeout(const Duration(seconds: 2));
      expect(result.reason, equals('cancelled'));
    });

    test('a cancelled registration is dropped, not merely answered', () async {
      final p = TestProjection('p4-gone');
      final ref = await spawnActor(p);

      final pending = ref.ask<AwaitFailed>(
        AwaitEventApplied((e) => e is TickEvent && e.n == 3,
            timeout: const Duration(seconds: 30), awaitId: 'a'),
      );
      final first = await ref.ask<EventAwaitCancelled>(CancelEventAwait('a'));
      expect(first.cancelled, equals(1));
      await pending.timeout(const Duration(seconds: 2));

      // Cancelled twice, with no event in between: the second cancel finds
      // nothing, because the first removed the registration rather than just
      // replying to it. (Answering without removing would leave a closure,
      // a reply target and a dead timer behind — the leak this exists to
      // close — and nothing else in the protocol would show it.)
      final second = await ref.ask<EventAwaitCancelled>(CancelEventAwait('a'));
      expect(second.cancelled, equals(0),
          reason: 'the registration was answered but left in place');

      // And the event it was waiting for resolves nothing now.
      stream.emit(TickEvent(3), 3);
      await waitFor(() => p.readModel.contains(3));
      final third = await ref.ask<EventAwaitCancelled>(CancelEventAwait('a'));
      expect(third.cancelled, equals(0));
    });

    test('cancelling an id that was never registered cancels nothing', () async {
      final p = TestProjection('p4-unknown');
      final ref = await spawnActor(p);

      final ack =
          await ref.ask<EventAwaitCancelled>(CancelEventAwait('never-used'));
      expect(ack.cancelled, equals(0));
    });

    test('a cancel drops only the registrations carrying that id', () async {
      final p = TestProjection('p4-selective');
      final ref = await spawnActor(p);

      final cancelled = ref.ask<AwaitFailed>(
        AwaitEventApplied((e) => e is TickEvent && e.n == 1,
            timeout: const Duration(seconds: 30), awaitId: 'doomed'),
      );
      final kept = ref.ask<EventAppliedResponse>(
        AwaitEventApplied((e) => e is TickEvent && e.n == 2,
            timeout: const Duration(seconds: 30), awaitId: 'kept'),
      );
      final anonymous = ref.ask<EventAppliedResponse>(
        AwaitEventApplied((e) => e is TickEvent && e.n == 3,
            timeout: const Duration(seconds: 30)),
      );

      final ack = await ref.ask<EventAwaitCancelled>(CancelEventAwait('doomed'));
      expect(ack.cancelled, equals(1),
          reason: 'an id names its own registrations and no others');
      expect((await cancelled.timeout(const Duration(seconds: 2))).reason,
          equals('cancelled'));

      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      stream.emit(TickEvent(3), 3);

      // The other two, including the one that named no id, still resolve.
      expect((await kept.timeout(const Duration(seconds: 2))).matchedEvent,
          isA<TickEvent>());
      expect((await anonymous.timeout(const Duration(seconds: 2))).matchedEvent,
          isA<TickEvent>());
    });

    test('AwaitEventApplied times out with AwaitFailed', () async {
      final p = TestProjection('p4');
      final ref = await spawnActor(p);

      final result = await ref.ask<AwaitFailed>(
        AwaitEventApplied(
          (_) => false,
          timeout: const Duration(milliseconds: 50),
        ),
      );
      expect(result.reason, equals('timeout'));
    });

    test(
        'handle() failure does not advance checkpoint and does not resolve awaiters',
        () async {
      final p = TestProjection('p5', failOn: {3});
      final ref = await spawnActor(p);

      final failedAwait = ref.ask<AwaitFailed>(
        AwaitEventApplied(
          (e) => e is TickEvent && e.n == 3,
          timeout: const Duration(milliseconds: 200),
        ),
      );

      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      stream.emit(TickEvent(3), 3); // throws inside handle
      stream.emit(TickEvent(4), 4);

      await waitFor(() => p.readModel.length == 4);

      // onError called for the throwing event.
      expect(p.errorCalls, equals(1));

      // Awaiter for event 3 must NOT have resolved as success.
      final res = await failedAwait;
      expect(res.reason, equals('timeout'));

      // Latest processed sequence reflects event 4 (events 1, 2, 4 succeeded;
      // event 3 threw and did not advance the checkpoint state).
      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.lastProcessedSequence, equals(4));
      expect(info.info.eventsProcessed,
          equals(3)); // 1, 2, 4 — event 3 did not count.
    });

    test('PauseProjection / ResumeProjection round trip', () async {
      final p = TestProjection('p6');
      final ref = await spawnActor(p);

      stream.emit(TickEvent(1), 1);
      await waitFor(() => p.readModel.length == 1);

      ref.tell(PauseProjection());
      // Drain the pause message through the mailbox before emitting.
      await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());

      stream.emit(TickEvent(2), 2);
      stream.emit(TickEvent(3), 3);
      // Give time for any (incorrectly) delivered events to be processed.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(p.readModel, equals([1]));

      ref.tell(ResumeProjection());
      // Drain resume through the mailbox so the subscription is re-attached
      // before we emit again. Broadcast streams drop events delivered while
      // no listener is attached, so events emitted before resume completes
      // would be lost.
      await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());

      stream.emit(TickEvent(4), 4);
      await waitFor(() => p.readModel.length == 2);
      expect(p.readModel, equals([1, 4]));

      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, equals(ProjectionStatus.running));
    });

    test('RebuildProjection calls reset and restarts subscription', () async {
      final p = TestProjection('p7');
      final ref = await spawnActor(p);

      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      await waitFor(() => p.readModel.length == 2);

      ref.tell(RebuildProjection());
      // Drain rebuild through the mailbox.
      await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());

      expect(p.resetCalls, equals(1));
      expect(p.readModel, isEmpty);

      stream.emit(TickEvent(3), 3);
      await waitFor(() => p.readModel.length == 1);
      expect(p.readModel, equals([3]));
    });

    test('StopProjection acks, terminates, and fails pending awaiters',
        () async {
      final p = TestProjection('p8');
      final ref = await spawnActor(p);

      // Register an awaiter that will never naturally complete.
      final pending = ref.ask<AwaitFailed>(
        AwaitEventApplied((_) => false, timeout: const Duration(seconds: 10)),
      );

      final ack = await ref.ask<StoppedAck>(StopProjection());
      expect(ack, isA<StoppedAck>());

      final failed = await pending;
      expect(failed.reason, equals('stopped'));

      // After stop, the actor is removed from the system.
      await waitFor(() => system.getActor(ref.id) == null);
    });

    test('GetProjectionInfo reports current state', () async {
      final p = TestProjection('p9');
      final ref = await spawnActor(p);

      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      await waitFor(() => p.readModel.length == 2);

      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.projectionId, equals('p9'));
      expect(info.info.status, equals(ProjectionStatus.running));
      expect(info.info.lastProcessedSequence, equals(2));
      expect(info.info.eventsProcessed, equals(2));
    });

    test('filters events by interestedEventTypes', () async {
      final p = TestProjection('p10');
      await spawnActor(p);

      stream.emit(NoiseEvent(), 1);
      stream.emit(TickEvent(1), 2);
      stream.emit(NoiseEvent(), 3);
      stream.emit(TickEvent(2), 4);

      await waitFor(() => p.readModel.length == 2);
      expect(p.readModel, equals([1, 2]));
    });

    test('appliedEvents stream fires after handle() completes, in order',
        () async {
      // Capture the actor instance so we can subscribe to its appliedEvents.
      // Pekko's ProjectionBehavior keeps the projection runtime hidden behind
      // an ActorRef; we expose the applied-events stream here because the
      // primary consumer (libspiffy adapters) needs post-applied semantics.
      late final ProjectionActor projectionActor;
      final p = TestProjection(
        'p-applied',
        handleHook: (event) async {
          // Force a delay so we can verify ordering: the stream must NOT
          // emit before handle() returns.
          await Future<void>.delayed(const Duration(milliseconds: 20));
        },
      );
      await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      final received = <int>[];
      final sub = projectionActor.appliedEvents.listen((e) {
        if (e is TickEvent) received.add(e.n);
      });

      for (var i = 1; i <= 5; i++) {
        stream.emit(TickEvent(i), i);
      }

      await waitFor(() => received.length == 5);
      expect(received, equals([1, 2, 3, 4, 5]),
          reason: 'appliedEvents must emit in projection processing order');
      // The readModel is updated inside handle(); if it has all 5, handle()
      // must have completed before each emission.
      expect(p.readModel, equals([1, 2, 3, 4, 5]));

      await sub.cancel();
    });

    test('appliedEventsWithSequence carries each event\'s journal sequence',
        () async {
      late final ProjectionActor projectionActor;
      final p = TestProjection('p-applied-seq');
      await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      final received = <(int, int)>[];
      final plain = <int>[];
      final sub = projectionActor.appliedEventsWithSequence.listen((applied) {
        final (event, sequence) = applied;
        if (event is TickEvent) received.add((event.n, sequence));
      });
      final plainSub = projectionActor.appliedEvents.listen((e) {
        if (e is TickEvent) plain.add(e.n);
      });

      stream.emit(TickEvent(1), 10);
      stream.emit(NoiseEvent(), 11);
      stream.emit(TickEvent(2), 12);

      await waitFor(() => received.length == 2 && plain.length == 2);
      expect(received, equals([(1, 10), (2, 12)]));
      expect(plain, equals([1, 2]),
          reason: 'appliedEvents still carries the events alone');

      await sub.cancel();
      await plainSub.cancel();
    });

    test('appliedEvents does NOT emit when handle() returns false', () async {
      // NoiseEvent is not in interestedEventTypes, so the projection's stream
      // filter drops it before _handleEvent is called. But even if a
      // NoiseEvent did reach _handleEvent (e.g., types share a registry),
      // handle() returns false and emission must be skipped.
      late final ProjectionActor projectionActor;
      final p = TestProjection('p-applied-skip');
      await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      final received = <Event>[];
      final sub = projectionActor.appliedEvents.listen(received.add);

      stream.emit(NoiseEvent(), 1);
      stream.emit(TickEvent(1), 2);
      stream.emit(NoiseEvent(), 3);
      stream.emit(TickEvent(2), 4);

      await waitFor(() => received.length == 2);
      expect(received.whereType<NoiseEvent>(), isEmpty,
          reason: 'NoiseEvent should never appear in appliedEvents');
      expect(received.whereType<TickEvent>().map((e) => e.n).toList(),
          equals([1, 2]));

      await sub.cancel();
    });

    test('appliedEvents does NOT emit when handle() throws', () async {
      late final ProjectionActor projectionActor;
      final p = TestProjection('p-applied-throw', failOn: {3});
      await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      final received = <int>[];
      final sub = projectionActor.appliedEvents.listen((e) {
        if (e is TickEvent) received.add(e.n);
      });

      for (var i = 1; i <= 5; i++) {
        stream.emit(TickEvent(i), i);
      }

      // Allow time for all events to be attempted.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(received, equals([1, 2, 4, 5]),
          reason:
              'event 3 threw in handle(), must not appear in appliedEvents');

      await sub.cancel();
    });

    test('appliedEvents stream supports multiple subscribers (broadcast)',
        () async {
      late final ProjectionActor projectionActor;
      final p = TestProjection('p-applied-broadcast');
      await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      final receivedA = <int>[];
      final receivedB = <int>[];
      final subA = projectionActor.appliedEvents.listen((e) {
        if (e is TickEvent) receivedA.add(e.n);
      });
      final subB = projectionActor.appliedEvents.listen((e) {
        if (e is TickEvent) receivedB.add(e.n);
      });

      for (var i = 1; i <= 3; i++) {
        stream.emit(TickEvent(i), i);
      }

      await waitFor(() => receivedA.length == 3 && receivedB.length == 3);
      expect(receivedA, equals([1, 2, 3]));
      expect(receivedB, equals([1, 2, 3]));

      await subA.cancel();
      await subB.cancel();
    });

    test('appliedEvents stream closes when StopProjection received', () async {
      late final ProjectionActor projectionActor;
      final p = TestProjection('p-applied-stop');
      final ref = await system.spawn(
        'projection-${p.projectionId}',
        () {
          projectionActor = ProjectionActor(p, stream);
          return projectionActor;
        },
      );

      var doneFired = false;
      final sub = projectionActor.appliedEvents.listen(
        (_) {},
        onDone: () => doneFired = true,
      );

      stream.emit(TickEvent(1), 1);
      await waitFor(() => p.readModel.length == 1);

      await ref.ask<StoppedAck>(StopProjection());
      await waitFor(() => doneFired);

      expect(doneFired, isTrue,
          reason: 'appliedEvents stream must signal onDone on StopProjection');
      await sub.cancel();
    });
  });

  group('ProjectionActor checkpoint read failure', () {
    late ActorSystem system;
    late InMemoryEventStream stream;

    setUp(() async {
      system = ActorSystem.create();
      stream = InMemoryEventStream();
    });

    tearDown(() async {
      await stream.close();
      await system.shutdown();
    });

    test('does not subscribe, reports error state, and drops nothing silently',
        () async {
      final p = TestProjection('cpfail');
      final ref = await system.spawn(
        'projection-cpfail',
        () => FlakyCheckpointActor(p, stream, failuresLeft: 1),
      );

      // Events flow past an unsubscribed projection: they must NOT be
      // applied from position 0.
      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(p.readModel, isEmpty);
      expect(p.errorCalls, 1);
      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.error);
      expect(info.info.lastError, contains('checkpoint store unavailable'));
    });

    test('ResumeProjection retries the read until it succeeds', () async {
      final p = TestProjection('cpretry');
      late FlakyCheckpointActor actor;
      final ref = await system.spawn(
        'projection-cpretry',
        () => actor = FlakyCheckpointActor(p, stream, failuresLeft: 2),
      );

      // First resume: still failing.
      ref.tell(ResumeProjection());
      await waitFor(() => actor.loadAttempts == 2);
      var info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.error);
      expect(p.errorCalls, 2);

      // Second resume: succeeds and subscribes.
      ref.tell(ResumeProjection());
      await waitFor(() => actor.loadAttempts == 3);
      info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.running);

      stream.emit(TickEvent(1), 1);
      await waitFor(() => p.readModel.length == 1);
      expect(p.readModel, [1]);
    });

    test('StopProjection works from the error state', () async {
      final p = TestProjection('cpstop');
      final ref = await system.spawn(
        'projection-cpstop',
        () => FlakyCheckpointActor(p, stream, failuresLeft: 1),
      );
      await ref.ask<StoppedAck>(StopProjection());
      expect(ref.isAlive, isFalse);
      expect(p.stopCalls, 1);
    });
  });

  group('ProjectionActor + Isar checkpoint parity', () {
    late ActorSystem system;
    late Directory tempDir;
    late Isar isar;
    late InMemoryEventStream stream;

    setUp(() async {
      EventRegistry.register<TickEvent>(
        'TickEvent',
        (map) => TickEvent(map['n'] as int),
      );

      tempDir = await Directory.systemTemp
          .createTemp('eventador_projection_actor_test_');
      await initIsarCoreForTests();
      isar = await Isar.open(
        IsarEventStore.allSchemas,
        directory: tempDir.path,
        name: 'projection_actor_test',
      );

      system = ActorSystem.create();
      stream = InMemoryEventStream();
    });

    tearDown(() async {
      await stream.close();
      await system.shutdown();
      if (isar.isOpen) await isar.close();
      await tempDir.delete(recursive: true);
      EventRegistry.clear();
    });

    test('a retried checkpoint read honours the persisted position', () async {
      await isar.writeTxn(() async {
        await isar.projectionCheckpoints.put(ProjectionCheckpoint()
          ..projectionId = 'cp3'
          ..lastProcessedSequence = 50
          ..lastUpdated = DateTime.now()
          ..eventsProcessed = 50);
      });

      final p = TestProjection('cp3');
      late FlakyCheckpointActor actor;
      final ref = await system.spawn(
        'projection-cp3',
        () => actor =
            FlakyCheckpointActor(p, stream, failuresLeft: 1, checkpoints: IsarProjectionCheckpointStore(isar)),
      );
      var info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.error);

      ref.tell(ResumeProjection());
      await waitFor(() => actor.loadAttempts == 2);
      info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.running);
      expect(info.info.lastProcessedSequence, 50);

      stream.emit(TickEvent(40), 40); // before the checkpoint: ignored
      stream.emit(TickEvent(60), 60);
      await waitFor(() => p.readModel.length == 1);
      expect(p.readModel, [60]);
    });

    test('a checkpoint write failure is reported but processing continues',
        () async {
      final p = TestProjection('cp4');
      final ref = await system.spawn(
        'projection-cp4',
        () => ProjectionActor(p, stream, checkpoints: IsarProjectionCheckpointStore(isar), checkpointBatchSize: 2),
      );
      stream.emit(TickEvent(1), 1);
      stream.emit(TickEvent(2), 2);
      await waitFor(() => p.readModel.length == 2);
      final written = await isar.projectionCheckpoints
          .where()
          .projectionIdEqualTo('cp4')
          .findFirst();
      expect(written!.lastProcessedSequence, 2);

      // Take the checkpoint store away.
      await isar.close();

      stream.emit(TickEvent(3), 3);
      stream.emit(TickEvent(4), 4);
      await waitFor(() => p.readModel.length == 4);
      await waitFor(() => p.errorCalls == 1);

      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.status, ProjectionStatus.running);
      expect(info.info.lastProcessedSequence, 4);
      expect(info.info.lastError, isNotNull);
    });

    test(
        'batched checkpoint: persists every N events, final flush on StopProjection',
        () async {
      final p = TestProjection('cp1');
      final ref = await system.spawn(
        'projection-${p.projectionId}',
        () => ProjectionActor(p, stream, checkpoints: IsarProjectionCheckpointStore(isar), checkpointBatchSize: 5),
      );

      for (var i = 1; i <= 12; i++) {
        stream.emit(TickEvent(i), i);
      }
      await waitFor(() => p.readModel.length == 12);

      // After 12 events with batch size 5, the checkpoint should be at 10
      // (two batched writes: at 5 and at 10). 11 and 12 are buffered.
      final mid = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo('cp1')
          .findFirst();
      expect(mid, isNotNull);
      expect(mid!.lastProcessedSequence, equals(10));

      // StopProjection must flush the pending checkpoint up to 12.
      await ref.ask<StoppedAck>(StopProjection());

      final after = await isar.projectionCheckpoints
          .filter()
          .projectionIdEqualTo('cp1')
          .findFirst();
      expect(after!.lastProcessedSequence, equals(12));
    });

    test('checkpoint loaded on start resumes from previous sequence', () async {
      // Pre-populate a checkpoint at sequence 50.
      await isar.writeTxn(() async {
        final entity = ProjectionCheckpoint()
          ..projectionId = 'cp2'
          ..lastProcessedSequence = 50
          ..lastUpdated = DateTime.now()
          ..eventsProcessed = 50;
        await isar.projectionCheckpoints.put(entity);
      });

      final p = TestProjection('cp2');
      final ref = await system.spawn(
        'projection-cp2',
        () => ProjectionActor(p, stream, checkpoints: IsarProjectionCheckpointStore(isar), checkpointBatchSize: 100),
      );

      // Events with envelopeId <= 50 must be filtered out by the
      // fromSequence query.
      stream.emit(TickEvent(40), 40); // ignored
      stream.emit(TickEvent(60), 60);
      stream.emit(TickEvent(70), 70);

      await waitFor(() => p.readModel.length == 2);
      expect(p.readModel, equals([60, 70]));

      final info = await ref.ask<ProjectionInfoResponse>(GetProjectionInfo());
      expect(info.info.lastProcessedSequence, equals(70));
    });
  });
}
