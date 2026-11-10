// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection_checkpoint.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProjectionCheckpointCollection on Isar {
  IsarCollection<ProjectionCheckpoint> get projectionCheckpoints =>
      this.collection();
}

const ProjectionCheckpointSchema = CollectionSchema(
  name: r'ProjectionCheckpoint',
  id: 6110110847672680481,
  properties: {
    r'averageProcessingTimeMs': PropertySchema(
      id: 0,
      name: r'averageProcessingTimeMs',
      type: IsarType.long,
    ),
    r'eventsProcessed': PropertySchema(
      id: 1,
      name: r'eventsProcessed',
      type: IsarType.long,
    ),
    r'lastError': PropertySchema(
      id: 2,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'lastProcessedSequence': PropertySchema(
      id: 3,
      name: r'lastProcessedSequence',
      type: IsarType.long,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'projectionId': PropertySchema(
      id: 5,
      name: r'projectionId',
      type: IsarType.string,
    ),
    r'projectionVersion': PropertySchema(
      id: 6,
      name: r'projectionVersion',
      type: IsarType.long,
    ),
    r'startedAt': PropertySchema(
      id: 7,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
      enumMap: _ProjectionCheckpointstatusEnumValueMap,
    )
  },
  estimateSize: _projectionCheckpointEstimateSize,
  serialize: _projectionCheckpointSerialize,
  deserialize: _projectionCheckpointDeserialize,
  deserializeProp: _projectionCheckpointDeserializeProp,
  idName: r'id',
  indexes: {
    r'projectionId': IndexSchema(
      id: 2018402644636811971,
      name: r'projectionId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'projectionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _projectionCheckpointGetId,
  getLinks: _projectionCheckpointGetLinks,
  attach: _projectionCheckpointAttach,
  version: '3.3.2',
);

int _projectionCheckpointEstimateSize(
  ProjectionCheckpoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.projectionId.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  return bytesCount;
}

void _projectionCheckpointSerialize(
  ProjectionCheckpoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.averageProcessingTimeMs);
  writer.writeLong(offsets[1], object.eventsProcessed);
  writer.writeString(offsets[2], object.lastError);
  writer.writeLong(offsets[3], object.lastProcessedSequence);
  writer.writeDateTime(offsets[4], object.lastUpdated);
  writer.writeString(offsets[5], object.projectionId);
  writer.writeLong(offsets[6], object.projectionVersion);
  writer.writeDateTime(offsets[7], object.startedAt);
  writer.writeString(offsets[8], object.status.name);
}

ProjectionCheckpoint _projectionCheckpointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProjectionCheckpoint();
  object.averageProcessingTimeMs = reader.readLongOrNull(offsets[0]);
  object.eventsProcessed = reader.readLong(offsets[1]);
  object.id = id;
  object.lastError = reader.readStringOrNull(offsets[2]);
  object.lastProcessedSequence = reader.readLong(offsets[3]);
  object.lastUpdated = reader.readDateTime(offsets[4]);
  object.projectionId = reader.readString(offsets[5]);
  object.projectionVersion = reader.readLong(offsets[6]);
  object.startedAt = reader.readDateTime(offsets[7]);
  object.status = _ProjectionCheckpointstatusValueEnumMap[
          reader.readStringOrNull(offsets[8])] ??
      ProjectionStatus.running;
  return object;
}

P _projectionCheckpointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (_ProjectionCheckpointstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          ProjectionStatus.running) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ProjectionCheckpointstatusEnumValueMap = {
  r'running': r'running',
  r'paused': r'paused',
  r'stopped': r'stopped',
  r'error': r'error',
};
const _ProjectionCheckpointstatusValueEnumMap = {
  r'running': ProjectionStatus.running,
  r'paused': ProjectionStatus.paused,
  r'stopped': ProjectionStatus.stopped,
  r'error': ProjectionStatus.error,
};

Id _projectionCheckpointGetId(ProjectionCheckpoint object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _projectionCheckpointGetLinks(
    ProjectionCheckpoint object) {
  return [];
}

void _projectionCheckpointAttach(
    IsarCollection<dynamic> col, Id id, ProjectionCheckpoint object) {
  object.id = id;
}

extension ProjectionCheckpointByIndex on IsarCollection<ProjectionCheckpoint> {
  Future<ProjectionCheckpoint?> getByProjectionId(String projectionId) {
    return getByIndex(r'projectionId', [projectionId]);
  }

  ProjectionCheckpoint? getByProjectionIdSync(String projectionId) {
    return getByIndexSync(r'projectionId', [projectionId]);
  }

  Future<bool> deleteByProjectionId(String projectionId) {
    return deleteByIndex(r'projectionId', [projectionId]);
  }

  bool deleteByProjectionIdSync(String projectionId) {
    return deleteByIndexSync(r'projectionId', [projectionId]);
  }

  Future<List<ProjectionCheckpoint?>> getAllByProjectionId(
      List<String> projectionIdValues) {
    final values = projectionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'projectionId', values);
  }

  List<ProjectionCheckpoint?> getAllByProjectionIdSync(
      List<String> projectionIdValues) {
    final values = projectionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'projectionId', values);
  }

  Future<int> deleteAllByProjectionId(List<String> projectionIdValues) {
    final values = projectionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'projectionId', values);
  }

  int deleteAllByProjectionIdSync(List<String> projectionIdValues) {
    final values = projectionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'projectionId', values);
  }

  Future<Id> putByProjectionId(ProjectionCheckpoint object) {
    return putByIndex(r'projectionId', object);
  }

  Id putByProjectionIdSync(ProjectionCheckpoint object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'projectionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByProjectionId(List<ProjectionCheckpoint> objects) {
    return putAllByIndex(r'projectionId', objects);
  }

  List<Id> putAllByProjectionIdSync(List<ProjectionCheckpoint> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'projectionId', objects, saveLinks: saveLinks);
  }
}

extension ProjectionCheckpointQueryWhereSort
    on QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QWhere> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProjectionCheckpointQueryWhere
    on QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QWhereClause> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
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

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      projectionIdEqualTo(String projectionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'projectionId',
        value: [projectionId],
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterWhereClause>
      projectionIdNotEqualTo(String projectionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectionId',
              lower: [],
              upper: [projectionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectionId',
              lower: [projectionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectionId',
              lower: [projectionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectionId',
              lower: [],
              upper: [projectionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProjectionCheckpointQueryFilter on QueryBuilder<ProjectionCheckpoint,
    ProjectionCheckpoint, QFilterCondition> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'averageProcessingTimeMs',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'averageProcessingTimeMs',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageProcessingTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageProcessingTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageProcessingTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> averageProcessingTimeMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageProcessingTimeMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> eventsProcessedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventsProcessed',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> eventsProcessedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventsProcessed',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> eventsProcessedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventsProcessed',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> eventsProcessedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventsProcessed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastProcessedSequenceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastProcessedSequence',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastProcessedSequenceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastProcessedSequence',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastProcessedSequenceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastProcessedSequence',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastProcessedSequenceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastProcessedSequence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      projectionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      projectionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectionId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectionVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectionVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> projectionVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectionVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusEqualTo(
    ProjectionStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusGreaterThan(
    ProjectionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusLessThan(
    ProjectionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusBetween(
    ProjectionStatus lower,
    ProjectionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension ProjectionCheckpointQueryObject on QueryBuilder<ProjectionCheckpoint,
    ProjectionCheckpoint, QFilterCondition> {}

extension ProjectionCheckpointQueryLinks on QueryBuilder<ProjectionCheckpoint,
    ProjectionCheckpoint, QFilterCondition> {}

extension ProjectionCheckpointQuerySortBy
    on QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QSortBy> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByAverageProcessingTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProcessingTimeMs', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByAverageProcessingTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProcessingTimeMs', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByEventsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventsProcessed', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByEventsProcessedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventsProcessed', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastProcessedSequence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedSequence', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastProcessedSequenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedSequence', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByProjectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionId', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByProjectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionId', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByProjectionVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionVersion', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByProjectionVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionVersion', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ProjectionCheckpointQuerySortThenBy
    on QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QSortThenBy> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByAverageProcessingTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProcessingTimeMs', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByAverageProcessingTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProcessingTimeMs', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByEventsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventsProcessed', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByEventsProcessedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventsProcessed', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastProcessedSequence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedSequence', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastProcessedSequenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedSequence', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByProjectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionId', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByProjectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionId', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByProjectionVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionVersion', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByProjectionVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionVersion', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ProjectionCheckpointQueryWhereDistinct
    on QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct> {
  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByAverageProcessingTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageProcessingTimeMs');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByEventsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventsProcessed');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByLastProcessedSequence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastProcessedSequence');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByProjectionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByProjectionVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionVersion');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionCheckpoint, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension ProjectionCheckpointQueryProperty on QueryBuilder<
    ProjectionCheckpoint, ProjectionCheckpoint, QQueryProperty> {
  QueryBuilder<ProjectionCheckpoint, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProjectionCheckpoint, int?, QQueryOperations>
      averageProcessingTimeMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageProcessingTimeMs');
    });
  }

  QueryBuilder<ProjectionCheckpoint, int, QQueryOperations>
      eventsProcessedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventsProcessed');
    });
  }

  QueryBuilder<ProjectionCheckpoint, String?, QQueryOperations>
      lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<ProjectionCheckpoint, int, QQueryOperations>
      lastProcessedSequenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastProcessedSequence');
    });
  }

  QueryBuilder<ProjectionCheckpoint, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<ProjectionCheckpoint, String, QQueryOperations>
      projectionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionId');
    });
  }

  QueryBuilder<ProjectionCheckpoint, int, QQueryOperations>
      projectionVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionVersion');
    });
  }

  QueryBuilder<ProjectionCheckpoint, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<ProjectionCheckpoint, ProjectionStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
