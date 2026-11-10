/// Isar storage for eventador: [IsarEventStore] (the event journal and
/// snapshots, and the `EventStream` over the journal) and
/// [IsarProjectionCheckpointStore].
///
/// A Flutter app must declare `isar_community_flutter_libs` itself to bundle
/// Isar's native library; a transitive dependency doesn't bundle it.
library;

export 'src/event_envelope.dart';
export 'src/isar_event_store.dart';
export 'src/projection_checkpoint.dart';
export 'src/snapshot_envelope.dart';
