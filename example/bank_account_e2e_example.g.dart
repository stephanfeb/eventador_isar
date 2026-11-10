// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_e2e_example.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountSummaryCollection on Isar {
  IsarCollection<AccountSummary> get accountSummarys => this.collection();
}

const AccountSummarySchema = CollectionSchema(
  name: r'AccountSummary',
  id: 8345838979924239414,
  properties: {
    r'accountHolder': PropertySchema(
      id: 0,
      name: r'accountHolder',
      type: IsarType.string,
    ),
    r'accountId': PropertySchema(
      id: 1,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'balance': PropertySchema(
      id: 2,
      name: r'balance',
      type: IsarType.double,
    ),
    r'isActive': PropertySchema(
      id: 3,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'openedAt': PropertySchema(
      id: 5,
      name: r'openedAt',
      type: IsarType.dateTime,
    ),
    r'totalDeposited': PropertySchema(
      id: 6,
      name: r'totalDeposited',
      type: IsarType.double,
    ),
    r'totalWithdrawn': PropertySchema(
      id: 7,
      name: r'totalWithdrawn',
      type: IsarType.double,
    ),
    r'transactionCount': PropertySchema(
      id: 8,
      name: r'transactionCount',
      type: IsarType.long,
    )
  },
  estimateSize: _accountSummaryEstimateSize,
  serialize: _accountSummarySerialize,
  deserialize: _accountSummaryDeserialize,
  deserializeProp: _accountSummaryDeserializeProp,
  idName: r'id',
  indexes: {
    r'accountId': IndexSchema(
      id: -1591555361937770434,
      name: r'accountId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accountId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _accountSummaryGetId,
  getLinks: _accountSummaryGetLinks,
  attach: _accountSummaryAttach,
  version: '3.3.2',
);

int _accountSummaryEstimateSize(
  AccountSummary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountHolder.length * 3;
  bytesCount += 3 + object.accountId.length * 3;
  return bytesCount;
}

void _accountSummarySerialize(
  AccountSummary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountHolder);
  writer.writeString(offsets[1], object.accountId);
  writer.writeDouble(offsets[2], object.balance);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeDateTime(offsets[4], object.lastUpdated);
  writer.writeDateTime(offsets[5], object.openedAt);
  writer.writeDouble(offsets[6], object.totalDeposited);
  writer.writeDouble(offsets[7], object.totalWithdrawn);
  writer.writeLong(offsets[8], object.transactionCount);
}

AccountSummary _accountSummaryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountSummary();
  object.accountHolder = reader.readString(offsets[0]);
  object.accountId = reader.readString(offsets[1]);
  object.balance = reader.readDouble(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.lastUpdated = reader.readDateTime(offsets[4]);
  object.openedAt = reader.readDateTime(offsets[5]);
  object.totalDeposited = reader.readDouble(offsets[6]);
  object.totalWithdrawn = reader.readDouble(offsets[7]);
  object.transactionCount = reader.readLong(offsets[8]);
  return object;
}

P _accountSummaryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountSummaryGetId(AccountSummary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _accountSummaryGetLinks(AccountSummary object) {
  return [];
}

void _accountSummaryAttach(
    IsarCollection<dynamic> col, Id id, AccountSummary object) {
  object.id = id;
}

extension AccountSummaryByIndex on IsarCollection<AccountSummary> {
  Future<AccountSummary?> getByAccountId(String accountId) {
    return getByIndex(r'accountId', [accountId]);
  }

  AccountSummary? getByAccountIdSync(String accountId) {
    return getByIndexSync(r'accountId', [accountId]);
  }

  Future<bool> deleteByAccountId(String accountId) {
    return deleteByIndex(r'accountId', [accountId]);
  }

  bool deleteByAccountIdSync(String accountId) {
    return deleteByIndexSync(r'accountId', [accountId]);
  }

  Future<List<AccountSummary?>> getAllByAccountId(
      List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'accountId', values);
  }

  List<AccountSummary?> getAllByAccountIdSync(List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'accountId', values);
  }

  Future<int> deleteAllByAccountId(List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'accountId', values);
  }

  int deleteAllByAccountIdSync(List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'accountId', values);
  }

  Future<Id> putByAccountId(AccountSummary object) {
    return putByIndex(r'accountId', object);
  }

  Id putByAccountIdSync(AccountSummary object, {bool saveLinks = true}) {
    return putByIndexSync(r'accountId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAccountId(List<AccountSummary> objects) {
    return putAllByIndex(r'accountId', objects);
  }

  List<Id> putAllByAccountIdSync(List<AccountSummary> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'accountId', objects, saveLinks: saveLinks);
  }
}

extension AccountSummaryQueryWhereSort
    on QueryBuilder<AccountSummary, AccountSummary, QWhere> {
  QueryBuilder<AccountSummary, AccountSummary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccountSummaryQueryWhere
    on QueryBuilder<AccountSummary, AccountSummary, QWhereClause> {
  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause> idBetween(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause>
      accountIdEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'accountId',
        value: [accountId],
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterWhereClause>
      accountIdNotEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [],
              upper: [accountId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [accountId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [accountId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [],
              upper: [accountId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AccountSummaryQueryFilter
    on QueryBuilder<AccountSummary, AccountSummary, QFilterCondition> {
  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountHolder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accountHolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accountHolder',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountHolder',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountHolderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accountHolder',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accountId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      accountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accountId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      balanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      balanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      balanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      balanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      lastUpdatedGreaterThan(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      lastUpdatedLessThan(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      lastUpdatedBetween(
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

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      openedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      openedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      openedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      openedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalDepositedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDeposited',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalDepositedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDeposited',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalDepositedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDeposited',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalDepositedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDeposited',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalWithdrawnEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalWithdrawn',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalWithdrawnGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalWithdrawn',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalWithdrawnLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalWithdrawn',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      totalWithdrawnBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalWithdrawn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      transactionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      transactionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      transactionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterFilterCondition>
      transactionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transactionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AccountSummaryQueryObject
    on QueryBuilder<AccountSummary, AccountSummary, QFilterCondition> {}

extension AccountSummaryQueryLinks
    on QueryBuilder<AccountSummary, AccountSummary, QFilterCondition> {}

extension AccountSummaryQuerySortBy
    on QueryBuilder<AccountSummary, AccountSummary, QSortBy> {
  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByAccountHolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountHolder', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByAccountHolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountHolder', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> sortByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTotalDeposited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDeposited', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTotalDepositedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDeposited', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTotalWithdrawn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithdrawn', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTotalWithdrawnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithdrawn', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionCount', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      sortByTransactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionCount', Sort.desc);
    });
  }
}

extension AccountSummaryQuerySortThenBy
    on QueryBuilder<AccountSummary, AccountSummary, QSortThenBy> {
  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByAccountHolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountHolder', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByAccountHolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountHolder', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy> thenByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTotalDeposited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDeposited', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTotalDepositedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDeposited', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTotalWithdrawn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithdrawn', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTotalWithdrawnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithdrawn', Sort.desc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionCount', Sort.asc);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QAfterSortBy>
      thenByTransactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionCount', Sort.desc);
    });
  }
}

extension AccountSummaryQueryWhereDistinct
    on QueryBuilder<AccountSummary, AccountSummary, QDistinct> {
  QueryBuilder<AccountSummary, AccountSummary, QDistinct>
      distinctByAccountHolder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountHolder',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct> distinctByAccountId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct> distinctByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openedAt');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct>
      distinctByTotalDeposited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDeposited');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct>
      distinctByTotalWithdrawn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalWithdrawn');
    });
  }

  QueryBuilder<AccountSummary, AccountSummary, QDistinct>
      distinctByTransactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionCount');
    });
  }
}

extension AccountSummaryQueryProperty
    on QueryBuilder<AccountSummary, AccountSummary, QQueryProperty> {
  QueryBuilder<AccountSummary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AccountSummary, String, QQueryOperations>
      accountHolderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountHolder');
    });
  }

  QueryBuilder<AccountSummary, String, QQueryOperations> accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<AccountSummary, double, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<AccountSummary, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<AccountSummary, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<AccountSummary, DateTime, QQueryOperations> openedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openedAt');
    });
  }

  QueryBuilder<AccountSummary, double, QQueryOperations>
      totalDepositedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDeposited');
    });
  }

  QueryBuilder<AccountSummary, double, QQueryOperations>
      totalWithdrawnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalWithdrawn');
    });
  }

  QueryBuilder<AccountSummary, int, QQueryOperations>
      transactionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionCount');
    });
  }
}
