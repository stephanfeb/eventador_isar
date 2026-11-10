// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot_envelope.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSnapshotEnvelopeCollection on Isar {
  IsarCollection<SnapshotEnvelope> get snapshotEnvelopes => this.collection();
}

const SnapshotEnvelopeSchema = CollectionSchema(
  name: r'SnapshotEnvelope',
  id: 2044741320658526508,
  properties: {
    r'metadataBytes': PropertySchema(
      id: 0,
      name: r'metadataBytes',
      type: IsarType.byteList,
    ),
    r'metadataData': PropertySchema(
      id: 1,
      name: r'metadataData',
      type: IsarType.longList,
    ),
    r'persistenceId': PropertySchema(
      id: 2,
      name: r'persistenceId',
      type: IsarType.string,
    ),
    r'schemaVersion': PropertySchema(
      id: 3,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'sequenceNumber': PropertySchema(
      id: 4,
      name: r'sequenceNumber',
      type: IsarType.long,
    ),
    r'sizeBytes': PropertySchema(
      id: 5,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'snapshotBytes': PropertySchema(
      id: 6,
      name: r'snapshotBytes',
      type: IsarType.byteList,
    ),
    r'snapshotData': PropertySchema(
      id: 7,
      name: r'snapshotData',
      type: IsarType.longList,
    ),
    r'stateType': PropertySchema(
      id: 8,
      name: r'stateType',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 9,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _snapshotEnvelopeEstimateSize,
  serialize: _snapshotEnvelopeSerialize,
  deserialize: _snapshotEnvelopeDeserialize,
  deserializeProp: _snapshotEnvelopeDeserializeProp,
  idName: r'id',
  indexes: {
    r'persistenceId': IndexSchema(
      id: -3073586296047114750,
      name: r'persistenceId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'persistenceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _snapshotEnvelopeGetId,
  getLinks: _snapshotEnvelopeGetLinks,
  attach: _snapshotEnvelopeAttach,
  version: '3.3.2',
);

int _snapshotEnvelopeEstimateSize(
  SnapshotEnvelope object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.metadataBytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.metadataData.length * 8;
  bytesCount += 3 + object.persistenceId.length * 3;
  {
    final value = object.snapshotBytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.snapshotData.length * 8;
  bytesCount += 3 + object.stateType.length * 3;
  return bytesCount;
}

void _snapshotEnvelopeSerialize(
  SnapshotEnvelope object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.metadataBytes);
  writer.writeLongList(offsets[1], object.metadataData);
  writer.writeString(offsets[2], object.persistenceId);
  writer.writeLong(offsets[3], object.schemaVersion);
  writer.writeLong(offsets[4], object.sequenceNumber);
  writer.writeLong(offsets[5], object.sizeBytes);
  writer.writeByteList(offsets[6], object.snapshotBytes);
  writer.writeLongList(offsets[7], object.snapshotData);
  writer.writeString(offsets[8], object.stateType);
  writer.writeDateTime(offsets[9], object.timestamp);
}

SnapshotEnvelope _snapshotEnvelopeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SnapshotEnvelope();
  object.id = id;
  object.metadataBytes = reader.readByteList(offsets[0]);
  object.metadataData = reader.readLongList(offsets[1]) ?? [];
  object.persistenceId = reader.readString(offsets[2]);
  object.schemaVersion = reader.readLong(offsets[3]);
  object.sequenceNumber = reader.readLong(offsets[4]);
  object.sizeBytes = reader.readLong(offsets[5]);
  object.snapshotBytes = reader.readByteList(offsets[6]);
  object.snapshotData = reader.readLongList(offsets[7]) ?? [];
  object.stateType = reader.readString(offsets[8]);
  object.timestamp = reader.readDateTime(offsets[9]);
  return object;
}

P _snapshotEnvelopeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readByteList(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readByteList(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _snapshotEnvelopeGetId(SnapshotEnvelope object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _snapshotEnvelopeGetLinks(SnapshotEnvelope object) {
  return [];
}

void _snapshotEnvelopeAttach(
    IsarCollection<dynamic> col, Id id, SnapshotEnvelope object) {
  object.id = id;
}

extension SnapshotEnvelopeByIndex on IsarCollection<SnapshotEnvelope> {
  Future<SnapshotEnvelope?> getByPersistenceId(String persistenceId) {
    return getByIndex(r'persistenceId', [persistenceId]);
  }

  SnapshotEnvelope? getByPersistenceIdSync(String persistenceId) {
    return getByIndexSync(r'persistenceId', [persistenceId]);
  }

  Future<bool> deleteByPersistenceId(String persistenceId) {
    return deleteByIndex(r'persistenceId', [persistenceId]);
  }

  bool deleteByPersistenceIdSync(String persistenceId) {
    return deleteByIndexSync(r'persistenceId', [persistenceId]);
  }

  Future<List<SnapshotEnvelope?>> getAllByPersistenceId(
      List<String> persistenceIdValues) {
    final values = persistenceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'persistenceId', values);
  }

  List<SnapshotEnvelope?> getAllByPersistenceIdSync(
      List<String> persistenceIdValues) {
    final values = persistenceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'persistenceId', values);
  }

  Future<int> deleteAllByPersistenceId(List<String> persistenceIdValues) {
    final values = persistenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'persistenceId', values);
  }

  int deleteAllByPersistenceIdSync(List<String> persistenceIdValues) {
    final values = persistenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'persistenceId', values);
  }

  Future<Id> putByPersistenceId(SnapshotEnvelope object) {
    return putByIndex(r'persistenceId', object);
  }

  Id putByPersistenceIdSync(SnapshotEnvelope object, {bool saveLinks = true}) {
    return putByIndexSync(r'persistenceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPersistenceId(List<SnapshotEnvelope> objects) {
    return putAllByIndex(r'persistenceId', objects);
  }

  List<Id> putAllByPersistenceIdSync(List<SnapshotEnvelope> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'persistenceId', objects, saveLinks: saveLinks);
  }
}

extension SnapshotEnvelopeQueryWhereSort
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QWhere> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SnapshotEnvelopeQueryWhere
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QWhereClause> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause>
      persistenceIdEqualTo(String persistenceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'persistenceId',
        value: [persistenceId],
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterWhereClause>
      persistenceIdNotEqualTo(String persistenceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId',
              lower: [],
              upper: [persistenceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId',
              lower: [persistenceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId',
              lower: [persistenceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId',
              lower: [],
              upper: [persistenceId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SnapshotEnvelopeQueryFilter
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QFilterCondition> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadataBytes',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadataBytes',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadataBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadataBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadataBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataBytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataBytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadataData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadataData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadataData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      metadataDataLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'metadataData',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'persistenceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'persistenceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'persistenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      persistenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'persistenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      schemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      schemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sequenceNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sequenceNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sequenceNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sequenceNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotBytes',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotBytes',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotBytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotBytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotData',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      snapshotDataLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshotData',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateType',
        value: '',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      stateTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateType',
        value: '',
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SnapshotEnvelopeQueryObject
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QFilterCondition> {}

extension SnapshotEnvelopeQueryLinks
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QFilterCondition> {}

extension SnapshotEnvelopeQuerySortBy
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QSortBy> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByPersistenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByPersistenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByStateType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateType', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByStateTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateType', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SnapshotEnvelopeQuerySortThenBy
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QSortThenBy> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByPersistenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByPersistenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByStateType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateType', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByStateTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateType', Sort.desc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SnapshotEnvelopeQueryWhereDistinct
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct> {
  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctByMetadataBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctByMetadataData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataData');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctByPersistenceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'persistenceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceNumber');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctBySnapshotBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctBySnapshotData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotData');
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctByStateType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension SnapshotEnvelopeQueryProperty
    on QueryBuilder<SnapshotEnvelope, SnapshotEnvelope, QQueryProperty> {
  QueryBuilder<SnapshotEnvelope, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SnapshotEnvelope, List<int>?, QQueryOperations>
      metadataBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, List<int>, QQueryOperations>
      metadataDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataData');
    });
  }

  QueryBuilder<SnapshotEnvelope, String, QQueryOperations>
      persistenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'persistenceId');
    });
  }

  QueryBuilder<SnapshotEnvelope, int, QQueryOperations>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<SnapshotEnvelope, int, QQueryOperations>
      sequenceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceNumber');
    });
  }

  QueryBuilder<SnapshotEnvelope, int, QQueryOperations> sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, List<int>?, QQueryOperations>
      snapshotBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotBytes');
    });
  }

  QueryBuilder<SnapshotEnvelope, List<int>, QQueryOperations>
      snapshotDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotData');
    });
  }

  QueryBuilder<SnapshotEnvelope, String, QQueryOperations> stateTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateType');
    });
  }

  QueryBuilder<SnapshotEnvelope, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
