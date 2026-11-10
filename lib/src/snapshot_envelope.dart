// Isar snapshot storage schema - Phase 1 Week 3 placeholder
// Snapshot envelope for storing actor state snapshots in Isar database

import 'dart:convert';
import 'package:isar_community/isar.dart';

part 'snapshot_envelope.g.dart';

/// Isar collection for storing actor state snapshots
/// Snapshots optimize recovery by avoiding replay of all events
@collection
class SnapshotEnvelope {
  /// Auto-incrementing ID for Isar
  Id id = Isar.autoIncrement;

  /// Persistence ID of the actor this snapshot belongs to
  /// Unique index ensures only one snapshot per actor (latest)
  @Index(unique: true)
  late String persistenceId;

  /// Sequence number of the last event included in this snapshot
  /// Used to determine which events to replay after snapshot
  late int sequenceNumber;

  /// CBOR-encoded snapshot data, as written before 4.2.0: eight bytes
  /// stored for each byte. Empty for a snapshot written since; read
  /// [payload].
  late List<int> snapshotData;

  /// CBOR-encoded snapshot data, one byte stored for each byte (since 4.2.0).
  List<byte>? snapshotBytes;

  /// Timestamp when the snapshot was created
  late DateTime timestamp;

  /// Type of the state (class name)
  /// Used for deserialization
  late String stateType;

  /// Schema version of the snapshot
  /// Used for snapshot migration and backward compatibility
  late int schemaVersion;

  /// Size of the snapshot in bytes
  /// Used for monitoring and cleanup policies
  late int sizeBytes;

  /// Additional metadata as key-value pairs (serialized as CBOR), as
  /// written before 4.2.0; empty since. Read [metadataPayload].
  late List<int> metadataData;

  /// The metadata, one byte stored for each byte (since 4.2.0).
  List<byte>? metadataBytes;

  SnapshotEnvelope();

  /// The CBOR-encoded state, wherever this envelope holds it.
  @ignore
  List<int> get payload => snapshotBytes ?? snapshotData;

  /// The CBOR-encoded metadata, wherever this envelope holds it.
  @ignore
  List<int> get metadataPayload => metadataBytes ?? metadataData;

  /// Sets [payload] and [metadataPayload], in the byte fields.
  void setPayload(List<int> state, List<int> metadata) {
    snapshotBytes = state;
    metadataBytes = metadata;
    snapshotData = const [];
    metadataData = const [];
  }

  // TODO: Implement in Phase 1 Week 3
  // - CBOR serialization/deserialization for state
  // - Snapshot compression for large states
  // - Snapshot cleanup and retention policies
  // - State type registry for deserialization
  // - Performance monitoring and metrics

  /// Serialize to JSON for backup
  Map<String, dynamic> toJson() {
    return {
      'persistenceId': persistenceId,
      'sequenceNumber': sequenceNumber,
      'snapshotData': base64Encode(payload),
      'timestamp': timestamp.toIso8601String(),
      'stateType': stateType,
      'schemaVersion': schemaVersion,
      'sizeBytes': sizeBytes,
      'metadataData': base64Encode(metadataPayload),
    };
  }

  /// Deserialize from JSON for restore
  factory SnapshotEnvelope.fromJson(Map<String, dynamic> json) {
    return SnapshotEnvelope()
      ..persistenceId = json['persistenceId'] as String
      ..sequenceNumber = json['sequenceNumber'] as int
      ..setPayload(base64Decode(json['snapshotData'] as String), base64Decode(json['metadataData'] as String))
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..stateType = json['stateType'] as String
      ..schemaVersion = json['schemaVersion'] as int
      ..sizeBytes = json['sizeBytes'] as int;
  }
}
