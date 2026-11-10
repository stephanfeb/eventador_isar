/// Audit F21: the persisted `ProjectionCheckpoint` row must reflect the
/// projection's status and last error, so an operator can read the health
/// of a projection from storage without a running actor.
library;

import 'dart:io';

import 'package:dactor/dactor.dart';
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';
import 'package:isar_community/isar.dart';
import 'package:test/test.dart';

import 'support/isar_core.dart';

class Tick extends Event {
  final int n;
  Tick(this.n);

  @override
  Map<String, dynamic> toMap() => super.toMap()..['n'] = n;

  static Tick fromMap(Map<String, dynamic> map) => Tick(map['n'] as int);
}

class TickProjection extends Projection<List<int>> {
  final String _id;
  final List<int> _seen = [];
  final Set<int> failOn;
  int errorCalls = 0;

  TickProjection(this._id, {this.failOn = const {}});

  @override
  String get projectionId => _id;

  @override
  List<int> get readModel => _seen;

  @override
  List<Type> get interestedEventTypes => [Tick];

  @override
  Future<bool> handle(Event event) async {
    final tick = event as Tick;
    if (failOn.contains(tick.n)) throw StateError('cannot handle ${tick.n}');
    _seen.add(tick.n);
    return true;
  }

  @override
  Future<void> onError(dynamic error, StackTrace stackTrace) async {
    errorCalls++;
  }

  @override
  Future<void> rebuild() async => reset();

  @override
  Future<void> reset() async => _seen.clear();

  @override
  Future<int> getCheckpoint() async => 0;

  @override
  Future<void> updateCheckpoint(int sequenceNumber) async {}
}

/// Fails the first [failuresLeft] checkpoint reads, then behaves normally.
class FlakyCheckpointActor extends ProjectionActor {
  int failuresLeft;

  FlakyCheckpointActor(super.projection, super.eventStream,
      {required super.checkpoints, this.failuresLeft = 1});

  @override
  Future<int> loadCheckpoint() async {
    if (failuresLeft > 0) {
      failuresLeft--;
      throw StateError('checkpoint store unavailable');
    }
    return super.loadCheckpoint();
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
  late Directory tempDir;
  late Isar isar;
  late IsarEventStore store;
  late ActorSystem system;

  setUp(() async {
    EventRegistry.register<Tick>('Tick', Tick.fromMap);
    tempDir = await Directory.systemTemp.createTemp('eventador_cp_status_');
    await initIsarCoreForTests();
    isar = await Isar.open(IsarEventStore.allSchemas,
        directory: tempDir.path, name: 'cp_status');
    store = IsarEventStore(isar);
    system = LocalActorSystem();
  });

  tearDown(() async {
    await system.shutdown();
    if (isar.isOpen) await isar.close();
    await tempDir.delete(recursive: true);
    EventRegistry.clear();
  });

  Future<ProjectionCheckpoint?> row(String id) =>
      isar.projectionCheckpoints.where().projectionIdEqualTo(id).findFirst();

  Future<ProjectionCheckpoint> rowWithStatus(
      String id, ProjectionStatus status) async {
    ProjectionCheckpoint? found;
    await waitFor(() {
      row(id).then((r) => found = r);
      return found?.status == status;
    }, reason: 'row $id to reach $status');
    return found!;
  }

  test('status follows start, pause, resume and stop', () async {
    final p = TickProjection('p1');
    final ref = await system.spawn(
        'proj-p1', () => ProjectionActor(p, store, checkpoints: IsarProjectionCheckpointStore(isar)));

    final started = await rowWithStatus('p1', ProjectionStatus.running);
    expect(started.lastError, isNull);

    ref.tell(PauseProjection());
    final paused = await rowWithStatus('p1', ProjectionStatus.paused);
    expect(
        paused.lastUpdated.isAfter(started.lastUpdated) ||
            paused.lastUpdated.isAtSameMomentAs(started.lastUpdated),
        isTrue);

    ref.tell(ResumeProjection());
    await rowWithStatus('p1', ProjectionStatus.running);

    await store.persistEvent('a', Tick(1), 0);
    await waitFor(() => p.readModel.length == 1);

    await ref.ask<StoppedAck>(StopProjection());
    final stopped = await row('p1');
    expect(stopped!.status, ProjectionStatus.stopped);
    expect(stopped.lastProcessedSequence, 1);
    expect(stopped.eventsProcessed, 1);
  });

  test('a handle() failure is recorded as lastError while running', () async {
    final p = TickProjection('p2', failOn: {2});
    final ref = await system.spawn(
        'proj-p2', () => ProjectionActor(p, store, checkpoints: IsarProjectionCheckpointStore(isar)));
    await rowWithStatus('p2', ProjectionStatus.running);

    await store.persistEvent('a', Tick(1), 0);
    await store.persistEvent('b', Tick(2), 0);
    await store.persistEvent('c', Tick(3), 0);
    await waitFor(() => p.readModel.length == 2 && p.errorCalls == 1);

    ProjectionCheckpoint? r;
    await waitFor(() {
      row('p2').then((x) => r = x);
      return r?.lastError != null;
    }, reason: 'lastError to be written');
    expect(r!.status, ProjectionStatus.running);
    expect(r!.lastError, contains('cannot handle 2'));

    await ref.ask<StoppedAck>(StopProjection());
    final stopped = await row('p2');
    expect(stopped!.status, ProjectionStatus.stopped);
    expect(stopped.lastError, contains('cannot handle 2'),
        reason: 'the last error stays visible after stop');
  });

  test('an unreadable checkpoint is recorded as the error status', () async {
    final p = TickProjection('p3');
    final ref = await system.spawn(
        'proj-p3', () => FlakyCheckpointActor(p, store, checkpoints: IsarProjectionCheckpointStore(isar)));

    final errored = await rowWithStatus('p3', ProjectionStatus.error);
    expect(errored.lastError, contains('checkpoint store unavailable'));

    ref.tell(ResumeProjection());
    final recovered = await rowWithStatus('p3', ProjectionStatus.running);
    expect(recovered.lastError, isNull,
        reason: 'a successful restart clears the error');

    await ref.ask<StoppedAck>(StopProjection());
  });

  test('a rebuild resets the position and clears lastError', () async {
    final p = TickProjection('p4', failOn: {1});
    final ref = await system.spawn(
        'proj-p4', () => ProjectionActor(p, store, checkpoints: IsarProjectionCheckpointStore(isar)));
    await rowWithStatus('p4', ProjectionStatus.running);

    await store.persistEvent('a', Tick(1), 0);
    await waitFor(() => p.errorCalls == 1);
    await store.persistEvent('b', Tick(2), 0);
    await waitFor(() => p.readModel.length == 1);
    await ref.ask<StoppedAck>(StopProjection());
    expect((await row('p4'))!.lastError, isNotNull);

    final p2 = TickProjection('p4');
    final ref2 = await system.spawn(
        'proj-p4-again', () => ProjectionActor(p2, store, checkpoints: IsarProjectionCheckpointStore(isar)));
    await rowWithStatus('p4', ProjectionStatus.running);
    ref2.tell(RebuildProjection());
    await waitFor(() => p2.readModel.length == 2,
        reason: 'rebuild to replay both events');

    final rebuilt = await row('p4');
    expect(rebuilt!.status, ProjectionStatus.running);
    expect(rebuilt.lastError, isNull);
    await ref2.ask<StoppedAck>(StopProjection());
  });

  test('an actor stopped by system shutdown leaves a stopped row', () async {
    final p = TickProjection('p5');
    await system.spawn('proj-p5', () => ProjectionActor(p, store, checkpoints: IsarProjectionCheckpointStore(isar)));
    await rowWithStatus('p5', ProjectionStatus.running);

    await system.shutdown();
    // postStop's write is fire-and-forget; give it a moment.
    await rowWithStatus('p5', ProjectionStatus.stopped);
  });
}
