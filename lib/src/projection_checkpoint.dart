import 'package:eventador/eventador.dart';
import 'package:isar_community/isar.dart';

part 'projection_checkpoint.g.dart';

/// The Isar row behind [IsarProjectionCheckpointStore]: one per projection.
///
/// See [ProjectionCheckpointRecord] for what the fields mean; this row also
/// carries a few that the store interface doesn't (start time, version,
/// metadata), kept so databases written before 5.0.0 read unchanged.
@collection
class ProjectionCheckpoint {
  Id id = Isar.autoIncrement;

  /// Unique identifier for the projection
  @Index(unique: true)
  late String projectionId;

  /// Last processed event sequence number
  late int lastProcessedSequence;

  /// Status as of [lastUpdated]: `running`, `paused`, `stopped`, or `error`
  /// (not subscribed; the checkpoint could not be read).
  @Enumerated(EnumType.name)
  late ProjectionStatus status;

  /// When this checkpoint was last updated
  late DateTime lastUpdated;

  /// Total number of events processed by this projection
  late int eventsProcessed;

  /// Average processing time per event in milliseconds
  int? averageProcessingTimeMs;

  /// Most recent failure: a `handle()` exception, an event-stream error, a
  /// checkpoint write failure, or the error that put the projection in the
  /// `error` status. Cleared when the projection (re)starts or rebuilds
  /// successfully.
  String? lastError;

  /// When the projection was started
  late DateTime startedAt;

  /// Version of the projection schema/logic
  late int projectionVersion;

  /// Additional metadata as key-value pairs
  @ignore
  late Map<String, String> metadata;

  ProjectionCheckpoint() {
    metadata = <String, String>{};
    eventsProcessed = 0;
    lastProcessedSequence = 0;
    projectionVersion = 1;
    startedAt = DateTime.now();
    lastUpdated = DateTime.now();
    status = ProjectionStatus.running;
  }

  /// Serialize to JSON for backup
  Map<String, dynamic> toJson() {
    return {
      'projectionId': projectionId,
      'lastProcessedSequence': lastProcessedSequence,
      'status': status.toString().split('.').last,
      'lastUpdated': lastUpdated.toIso8601String(),
      'eventsProcessed': eventsProcessed,
      'averageProcessingTimeMs': averageProcessingTimeMs,
      'lastError': lastError,
      'startedAt': startedAt.toIso8601String(),
      'projectionVersion': projectionVersion,
      'metadata': metadata,
    };
  }

  /// Deserialize from JSON for restore
  factory ProjectionCheckpoint.fromJson(Map<String, dynamic> json) {
    return ProjectionCheckpoint()
      ..projectionId = json['projectionId'] as String
      ..lastProcessedSequence = json['lastProcessedSequence'] as int
      ..status = ProjectionStatus.values
          .firstWhere((e) => e.toString().split('.').last == json['status'])
      ..lastUpdated = DateTime.parse(json['lastUpdated'] as String)
      ..eventsProcessed = json['eventsProcessed'] as int
      ..averageProcessingTimeMs = json['averageProcessingTimeMs'] as int?
      ..lastError = json['lastError'] as String?
      ..startedAt = DateTime.parse(json['startedAt'] as String)
      ..projectionVersion = json['projectionVersion'] as int
      ..metadata =
          (json['metadata'] as Map<String, dynamic>).cast<String, String>();
  }
}

/// A [ProjectionCheckpointStore] in an Isar database opened with
/// [IsarEventStore.projectionSchemas] (as [IsarEventStore.create] does):
/// `ProjectionActor(..., checkpoints: IsarProjectionCheckpointStore(isar))`.
class IsarProjectionCheckpointStore implements ProjectionCheckpointStore {
  final Isar _isar;

  IsarProjectionCheckpointStore(this._isar);

  @override
  Future<ProjectionCheckpointRecord?> read(String projectionId) async {
    final row = await _isar.projectionCheckpoints
        .where()
        .projectionIdEqualTo(projectionId)
        .findFirst();
    if (row == null) return null;
    return ProjectionCheckpointRecord(
      projectionId: row.projectionId,
      lastProcessedSequence: row.lastProcessedSequence,
      status: row.status,
      lastError: row.lastError,
      lastUpdated: row.lastUpdated,
      eventsProcessed: row.eventsProcessed,
    );
  }

  @override
  Future<void> write(
    String projectionId, {
    int? lastProcessedSequence,
    required ProjectionStatus status,
    required String? lastError,
    required DateTime lastUpdated,
    required int eventsProcessed,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.projectionCheckpoints
          .where()
          .projectionIdEqualTo(projectionId)
          .findFirst();
      final row =
          existing ?? (ProjectionCheckpoint()..projectionId = projectionId);
      if (lastProcessedSequence != null) {
        row.lastProcessedSequence = lastProcessedSequence;
      }
      row
        ..status = status
        ..lastError = lastError
        ..lastUpdated = lastUpdated
        ..eventsProcessed = eventsProcessed;
      await _isar.projectionCheckpoints.put(row);
    });
  }
}
