## 1.0.0

Isar storage for eventador, split out of eventador 5.0.0 so that eventador itself no longer depends on Isar.

- `IsarEventStore`, `EventEnvelope`, `SnapshotEnvelope` and the `ProjectionCheckpoint` collection, as they were in eventador 4.2.1. The Isar schemas are byte-for-byte the same, so a database written by eventador 4.x opens unchanged.
- `IsarEventStore` implements eventador's new `PurgeableEventStore` (`deleteEvents`, which it already had), and its size limit is eventador's `journalMaxPayloadBytes`.
- `IsarProjectionCheckpointStore`: eventador's `ProjectionCheckpointStore` over the `ProjectionCheckpoint` collection, for `ProjectionActor(..., checkpoints: ...)`, which replaces `isar: isar`.
- `ProjectionReadModel` and `ProjectionReadModelIndex` were not carried over: they had no generated schema, so they could never be stored.
