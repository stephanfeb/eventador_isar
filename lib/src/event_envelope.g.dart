// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_envelope.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEventEnvelopeCollection on Isar {
  IsarCollection<EventEnvelope> get eventEnvelopes => this.collection();
}

const EventEnvelopeSchema = CollectionSchema(
  name: r'EventEnvelope',
  id: -8402211260685259666,
  properties: {
    r'eventBytes': PropertySchema(
      id: 0,
      name: r'eventBytes',
      type: IsarType.byteList,
    ),
    r'eventData': PropertySchema(
      id: 1,
      name: r'eventData',
      type: IsarType.longList,
    ),
    r'eventId': PropertySchema(
      id: 2,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'eventType': PropertySchema(
      id: 3,
      name: r'eventType',
      type: IsarType.string,
    ),
    r'metadataBytes': PropertySchema(
      id: 4,
      name: r'metadataBytes',
      type: IsarType.byteList,
    ),
    r'metadataData': PropertySchema(
      id: 5,
      name: r'metadataData',
      type: IsarType.longList,
    ),
    r'persistenceId': PropertySchema(
      id: 6,
      name: r'persistenceId',
      type: IsarType.string,
    ),
    r'schemaVersion': PropertySchema(
      id: 7,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'sequenceNumber': PropertySchema(
      id: 8,
      name: r'sequenceNumber',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 9,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _eventEnvelopeEstimateSize,
  serialize: _eventEnvelopeSerialize,
  deserialize: _eventEnvelopeDeserialize,
  deserializeProp: _eventEnvelopeDeserializeProp,
  idName: r'id',
  indexes: {
    r'persistenceId_sequenceNumber': IndexSchema(
      id: 4145362399372155436,
      name: r'persistenceId_sequenceNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'persistenceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'sequenceNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _eventEnvelopeGetId,
  getLinks: _eventEnvelopeGetLinks,
  attach: _eventEnvelopeAttach,
  version: '3.3.2',
);

int _eventEnvelopeEstimateSize(
  EventEnvelope object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.eventBytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.eventData.length * 8;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.eventType.length * 3;
  {
    final value = object.metadataBytes;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  bytesCount += 3 + object.metadataData.length * 8;
  bytesCount += 3 + object.persistenceId.length * 3;
  return bytesCount;
}

void _eventEnvelopeSerialize(
  EventEnvelope object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(offsets[0], object.eventBytes);
  writer.writeLongList(offsets[1], object.eventData);
  writer.writeString(offsets[2], object.eventId);
  writer.writeString(offsets[3], object.eventType);
  writer.writeByteList(offsets[4], object.metadataBytes);
  writer.writeLongList(offsets[5], object.metadataData);
  writer.writeString(offsets[6], object.persistenceId);
  writer.writeLong(offsets[7], object.schemaVersion);
  writer.writeLong(offsets[8], object.sequenceNumber);
  writer.writeDateTime(offsets[9], object.timestamp);
}

EventEnvelope _eventEnvelopeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EventEnvelope();
  object.eventBytes = reader.readByteList(offsets[0]);
  object.eventData = reader.readLongList(offsets[1]) ?? [];
  object.eventId = reader.readString(offsets[2]);
  object.eventType = reader.readString(offsets[3]);
  object.id = id;
  object.metadataBytes = reader.readByteList(offsets[4]);
  object.metadataData = reader.readLongList(offsets[5]) ?? [];
  object.persistenceId = reader.readString(offsets[6]);
  object.schemaVersion = reader.readLong(offsets[7]);
  object.sequenceNumber = reader.readLong(offsets[8]);
  object.timestamp = reader.readDateTime(offsets[9]);
  return object;
}

P _eventEnvelopeDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readByteList(offset)) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eventEnvelopeGetId(EventEnvelope object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eventEnvelopeGetLinks(EventEnvelope object) {
  return [];
}

void _eventEnvelopeAttach(
    IsarCollection<dynamic> col, Id id, EventEnvelope object) {
  object.id = id;
}

extension EventEnvelopeByIndex on IsarCollection<EventEnvelope> {
  Future<EventEnvelope?> getByEventId(String eventId) {
    return getByIndex(r'eventId', [eventId]);
  }

  EventEnvelope? getByEventIdSync(String eventId) {
    return getByIndexSync(r'eventId', [eventId]);
  }

  Future<bool> deleteByEventId(String eventId) {
    return deleteByIndex(r'eventId', [eventId]);
  }

  bool deleteByEventIdSync(String eventId) {
    return deleteByIndexSync(r'eventId', [eventId]);
  }

  Future<List<EventEnvelope?>> getAllByEventId(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'eventId', values);
  }

  List<EventEnvelope?> getAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'eventId', values);
  }

  Future<int> deleteAllByEventId(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'eventId', values);
  }

  int deleteAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'eventId', values);
  }

  Future<Id> putByEventId(EventEnvelope object) {
    return putByIndex(r'eventId', object);
  }

  Id putByEventIdSync(EventEnvelope object, {bool saveLinks = true}) {
    return putByIndexSync(r'eventId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEventId(List<EventEnvelope> objects) {
    return putAllByIndex(r'eventId', objects);
  }

  List<Id> putAllByEventIdSync(List<EventEnvelope> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'eventId', objects, saveLinks: saveLinks);
  }
}

extension EventEnvelopeQueryWhereSort
    on QueryBuilder<EventEnvelope, EventEnvelope, QWhere> {
  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EventEnvelopeQueryWhere
    on QueryBuilder<EventEnvelope, EventEnvelope, QWhereClause> {
  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> idBetween(
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdEqualToAnySequenceNumber(String persistenceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'persistenceId_sequenceNumber',
        value: [persistenceId],
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdNotEqualToAnySequenceNumber(String persistenceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [],
              upper: [persistenceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [],
              upper: [persistenceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdSequenceNumberEqualTo(
          String persistenceId, int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'persistenceId_sequenceNumber',
        value: [persistenceId, sequenceNumber],
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdEqualToSequenceNumberNotEqualTo(
          String persistenceId, int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId],
              upper: [persistenceId, sequenceNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId, sequenceNumber],
              includeLower: false,
              upper: [persistenceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId, sequenceNumber],
              includeLower: false,
              upper: [persistenceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'persistenceId_sequenceNumber',
              lower: [persistenceId],
              upper: [persistenceId, sequenceNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdEqualToSequenceNumberGreaterThan(
    String persistenceId,
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'persistenceId_sequenceNumber',
        lower: [persistenceId, sequenceNumber],
        includeLower: include,
        upper: [persistenceId],
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdEqualToSequenceNumberLessThan(
    String persistenceId,
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'persistenceId_sequenceNumber',
        lower: [persistenceId],
        upper: [persistenceId, sequenceNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      persistenceIdEqualToSequenceNumberBetween(
    String persistenceId,
    int lowerSequenceNumber,
    int upperSequenceNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'persistenceId_sequenceNumber',
        lower: [persistenceId, lowerSequenceNumber],
        includeLower: includeLower,
        upper: [persistenceId, upperSequenceNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause> eventIdEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterWhereClause>
      eventIdNotEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EventEnvelopeQueryFilter
    on QueryBuilder<EventEnvelope, EventEnvelope, QFilterCondition> {
  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eventBytes',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eventBytes',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventBytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventBytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventData',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventData',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventData',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventDataLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventData',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      eventTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      metadataBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadataBytes',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      metadataBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadataBytes',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      metadataBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      metadataDataElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataData',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      persistenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'persistenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      persistenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'persistenceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      persistenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'persistenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      persistenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'persistenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      sequenceNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterFilterCondition>
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

extension EventEnvelopeQueryObject
    on QueryBuilder<EventEnvelope, EventEnvelope, QFilterCondition> {}

extension EventEnvelopeQueryLinks
    on QueryBuilder<EventEnvelope, EventEnvelope, QFilterCondition> {}

extension EventEnvelopeQuerySortBy
    on QueryBuilder<EventEnvelope, EventEnvelope, QSortBy> {
  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> sortByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortByPersistenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortByPersistenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension EventEnvelopeQuerySortThenBy
    on QueryBuilder<EventEnvelope, EventEnvelope, QSortThenBy> {
  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenByPersistenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenByPersistenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistenceId', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension EventEnvelopeQueryWhereDistinct
    on QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> {
  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByEventBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventBytes');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByEventData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventData');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByEventType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct>
      distinctByMetadataBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataBytes');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct>
      distinctByMetadataData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataData');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByPersistenceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'persistenceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct>
      distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct>
      distinctBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceNumber');
    });
  }

  QueryBuilder<EventEnvelope, EventEnvelope, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension EventEnvelopeQueryProperty
    on QueryBuilder<EventEnvelope, EventEnvelope, QQueryProperty> {
  QueryBuilder<EventEnvelope, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EventEnvelope, List<int>?, QQueryOperations>
      eventBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventBytes');
    });
  }

  QueryBuilder<EventEnvelope, List<int>, QQueryOperations> eventDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventData');
    });
  }

  QueryBuilder<EventEnvelope, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<EventEnvelope, String, QQueryOperations> eventTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventType');
    });
  }

  QueryBuilder<EventEnvelope, List<int>?, QQueryOperations>
      metadataBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataBytes');
    });
  }

  QueryBuilder<EventEnvelope, List<int>, QQueryOperations>
      metadataDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataData');
    });
  }

  QueryBuilder<EventEnvelope, String, QQueryOperations>
      persistenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'persistenceId');
    });
  }

  QueryBuilder<EventEnvelope, int, QQueryOperations> schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<EventEnvelope, int, QQueryOperations> sequenceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceNumber');
    });
  }

  QueryBuilder<EventEnvelope, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
