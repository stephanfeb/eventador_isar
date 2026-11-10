# eventador_isar

Isar storage for [eventador](https://github.com/twostack/eventador): the event journal, snapshots and projection checkpoints in an [Isar](https://github.com/isar-community/isar-community) database.

eventador itself stores them in SQLite (`SqliteEventStore`) and has no Isar dependency. Use this package to keep an existing Isar journal, or to share one Isar database with other Isar collections.

## Install

```yaml
dependencies:
  eventador: ^5.0.0
  eventador_isar: ^1.0.0

  # Flutter apps only: bundles Isar's native library. It must be declared by
  # the app itself; a transitive dependency doesn't bundle the binary.
  isar_community_flutter_libs: 3.3.2
```

The generated schemas are tied to exactly `isar_community` 3.3.2; another version fails to compile with "Outdated generated code".

On macOS and iOS the published 3.3.2 binary preallocates the whole new file size past the end of the database file each time it grows (isar-community/isar-community#129). Until a fixed release is out, override `isar_community` and `isar_community_flutter_libs` with a build on libmdbx 0.13.12.

## Use

```dart
import 'package:eventador/eventador.dart';
import 'package:eventador_isar/eventador_isar.dart';

// Opens (or creates) an Isar database with the journal, snapshot and
// checkpoint collections. downloadIsarCore: false in an app that bundles the
// native library, so a missing one fails at once instead of reaching the
// network.
final store = await IsarEventStore.create(
  directory: dir,
  downloadIsarCore: false,
);

// Projections checkpoint into the same database.
ProjectionActor(projection, store,
    checkpoints: IsarProjectionCheckpointStore(store.isar));
```

To share a database, open it yourself with `IsarEventStore.allSchemas` (or `requiredSchemas` without projection checkpoints) beside your own schemas, and pass it to `IsarEventStore(isar)`.

`IsarEventStore` behaves like `SqliteEventStore` wherever a host could notice: events and states are encoded the same way, one snapshot is kept per persistence id, an event over `journalMaxPayloadBytes` (15 MiB) is refused before anything is written, and it implements `EventStream` and `PurgeableEventStore`.

## Tests

`dart test`. The first run downloads Isar's native library once into `.dart_tool/isar_core/` (see `test/support/isar_core.dart`), so it needs network access then.
