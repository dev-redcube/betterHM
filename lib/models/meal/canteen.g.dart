// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canteen.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCanteenCollection on Isar {
  IsarCollection<Canteen> get canteens => this.collection();
}

const CanteenSchema = CollectionSchema(
  name: r'Canteen',
  id: -7448407256781287192,
  properties: {
    r'canteenId': PropertySchema(
      id: 0,
      name: r'canteenId',
      type: IsarType.string,
    ),
    r'enumName': PropertySchema(
      id: 1,
      name: r'enumName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'openHours': PropertySchema(
      id: 3,
      name: r'openHours',
      type: IsarType.object,
      target: r'OpenHoursWeek',
    )
  },
  estimateSize: _canteenEstimateSize,
  serialize: _canteenSerialize,
  deserialize: _canteenDeserialize,
  deserializeProp: _canteenDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'OpenHoursWeek': OpenHoursWeekSchema,
    r'OpenHoursDay': OpenHoursDaySchema
  },
  getId: _canteenGetId,
  getLinks: _canteenGetLinks,
  attach: _canteenAttach,
  version: '3.0.5',
);

int _canteenEstimateSize(
  Canteen object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.canteenId.length * 3;
  bytesCount += 3 + object.enumName.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.openHours;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursWeekSchema.estimateSize(
              value, allOffsets[OpenHoursWeek]!, allOffsets);
    }
  }
  return bytesCount;
}

void _canteenSerialize(
  Canteen object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.canteenId);
  writer.writeString(offsets[1], object.enumName);
  writer.writeString(offsets[2], object.name);
  writer.writeObject<OpenHoursWeek>(
    offsets[3],
    allOffsets,
    OpenHoursWeekSchema.serialize,
    object.openHours,
  );
}

Canteen _canteenDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Canteen(
    reader.readString(offsets[1]),
    reader.readString(offsets[2]),
    reader.readString(offsets[0]),
    reader.readObjectOrNull<OpenHoursWeek>(
      offsets[3],
      OpenHoursWeekSchema.deserialize,
      allOffsets,
    ),
  );
  object.id = id;
  return object;
}

P _canteenDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<OpenHoursWeek>(
        offset,
        OpenHoursWeekSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _canteenGetId(Canteen object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _canteenGetLinks(Canteen object) {
  return [];
}

void _canteenAttach(IsarCollection<dynamic> col, Id id, Canteen object) {
  object.id = id;
}

extension CanteenQueryWhereSort on QueryBuilder<Canteen, Canteen, QWhere> {
  QueryBuilder<Canteen, Canteen, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CanteenQueryWhere on QueryBuilder<Canteen, Canteen, QWhereClause> {
  QueryBuilder<Canteen, Canteen, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Canteen, Canteen, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterWhereClause> idBetween(
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
}

extension CanteenQueryFilter
    on QueryBuilder<Canteen, Canteen, QFilterCondition> {
  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canteenId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'canteenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'canteenId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canteenId',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> canteenIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'canteenId',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enumName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'enumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'enumName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enumName',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> enumNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'enumName',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> openHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openHours',
      ));
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> openHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openHours',
      ));
    });
  }
}

extension CanteenQueryObject
    on QueryBuilder<Canteen, Canteen, QFilterCondition> {
  QueryBuilder<Canteen, Canteen, QAfterFilterCondition> openHours(
      FilterQuery<OpenHoursWeek> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'openHours');
    });
  }
}

extension CanteenQueryLinks
    on QueryBuilder<Canteen, Canteen, QFilterCondition> {}

extension CanteenQuerySortBy on QueryBuilder<Canteen, Canteen, QSortBy> {
  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByCanteenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canteenId', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByCanteenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canteenId', Sort.desc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByEnumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumName', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByEnumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumName', Sort.desc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CanteenQuerySortThenBy
    on QueryBuilder<Canteen, Canteen, QSortThenBy> {
  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByCanteenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canteenId', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByCanteenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canteenId', Sort.desc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByEnumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumName', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByEnumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumName', Sort.desc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Canteen, Canteen, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CanteenQueryWhereDistinct
    on QueryBuilder<Canteen, Canteen, QDistinct> {
  QueryBuilder<Canteen, Canteen, QDistinct> distinctByCanteenId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canteenId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Canteen, Canteen, QDistinct> distinctByEnumName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enumName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Canteen, Canteen, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension CanteenQueryProperty
    on QueryBuilder<Canteen, Canteen, QQueryProperty> {
  QueryBuilder<Canteen, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Canteen, String, QQueryOperations> canteenIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canteenId');
    });
  }

  QueryBuilder<Canteen, String, QQueryOperations> enumNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enumName');
    });
  }

  QueryBuilder<Canteen, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Canteen, OpenHoursWeek?, QQueryOperations> openHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openHours');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const OpenHoursWeekSchema = Schema(
  name: r'OpenHoursWeek',
  id: 4893627954256231776,
  properties: {
    r'fri': PropertySchema(
      id: 0,
      name: r'fri',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'mon': PropertySchema(
      id: 1,
      name: r'mon',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'sat': PropertySchema(
      id: 2,
      name: r'sat',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'sun': PropertySchema(
      id: 3,
      name: r'sun',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'thu': PropertySchema(
      id: 4,
      name: r'thu',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'tue': PropertySchema(
      id: 5,
      name: r'tue',
      type: IsarType.object,
      target: r'OpenHoursDay',
    ),
    r'wed': PropertySchema(
      id: 6,
      name: r'wed',
      type: IsarType.object,
      target: r'OpenHoursDay',
    )
  },
  estimateSize: _openHoursWeekEstimateSize,
  serialize: _openHoursWeekSerialize,
  deserialize: _openHoursWeekDeserialize,
  deserializeProp: _openHoursWeekDeserializeProp,
);

int _openHoursWeekEstimateSize(
  OpenHoursWeek object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.fri;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.mon;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.sat;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.sun;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.thu;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.tue;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  {
    final value = object.wed;
    if (value != null) {
      bytesCount += 3 +
          OpenHoursDaySchema.estimateSize(
              value, allOffsets[OpenHoursDay]!, allOffsets);
    }
  }
  return bytesCount;
}

void _openHoursWeekSerialize(
  OpenHoursWeek object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<OpenHoursDay>(
    offsets[0],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.fri,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[1],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.mon,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[2],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.sat,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[3],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.sun,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[4],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.thu,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[5],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.tue,
  );
  writer.writeObject<OpenHoursDay>(
    offsets[6],
    allOffsets,
    OpenHoursDaySchema.serialize,
    object.wed,
  );
}

OpenHoursWeek _openHoursWeekDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpenHoursWeek(
    fri: reader.readObjectOrNull<OpenHoursDay>(
      offsets[0],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    mon: reader.readObjectOrNull<OpenHoursDay>(
      offsets[1],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    sat: reader.readObjectOrNull<OpenHoursDay>(
      offsets[2],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    sun: reader.readObjectOrNull<OpenHoursDay>(
      offsets[3],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    thu: reader.readObjectOrNull<OpenHoursDay>(
      offsets[4],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    tue: reader.readObjectOrNull<OpenHoursDay>(
      offsets[5],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
    wed: reader.readObjectOrNull<OpenHoursDay>(
      offsets[6],
      OpenHoursDaySchema.deserialize,
      allOffsets,
    ),
  );
  return object;
}

P _openHoursWeekDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 3:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 5:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readObjectOrNull<OpenHoursDay>(
        offset,
        OpenHoursDaySchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OpenHoursWeekQueryFilter
    on QueryBuilder<OpenHoursWeek, OpenHoursWeek, QFilterCondition> {
  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      friIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fri',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      friIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fri',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      monIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mon',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      monIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mon',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      satIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sat',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      satIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sat',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      sunIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sun',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      sunIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sun',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      thuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thu',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      thuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thu',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      tueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tue',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      tueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tue',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      wedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wed',
      ));
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition>
      wedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wed',
      ));
    });
  }
}

extension OpenHoursWeekQueryObject
    on QueryBuilder<OpenHoursWeek, OpenHoursWeek, QFilterCondition> {
  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> fri(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'fri');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> mon(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'mon');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> sat(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sat');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> sun(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sun');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> thu(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'thu');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> tue(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tue');
    });
  }

  QueryBuilder<OpenHoursWeek, OpenHoursWeek, QAfterFilterCondition> wed(
      FilterQuery<OpenHoursDay> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'wed');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const OpenHoursDaySchema = Schema(
  name: r'OpenHoursDay',
  id: 3996551845230943251,
  properties: {
    r'end': PropertySchema(
      id: 0,
      name: r'end',
      type: IsarType.string,
    ),
    r'start': PropertySchema(
      id: 1,
      name: r'start',
      type: IsarType.string,
    )
  },
  estimateSize: _openHoursDayEstimateSize,
  serialize: _openHoursDaySerialize,
  deserialize: _openHoursDayDeserialize,
  deserializeProp: _openHoursDayDeserializeProp,
);

int _openHoursDayEstimateSize(
  OpenHoursDay object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.end;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.start;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _openHoursDaySerialize(
  OpenHoursDay object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.end);
  writer.writeString(offsets[1], object.start);
}

OpenHoursDay _openHoursDayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpenHoursDay(
    end: reader.readStringOrNull(offsets[0]),
    start: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _openHoursDayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OpenHoursDayQueryFilter
    on QueryBuilder<OpenHoursDay, OpenHoursDay, QFilterCondition> {
  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      endIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      endGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'end',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> endIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: '',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      endIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'end',
        value: '',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'start',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition> startMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'start',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: '',
      ));
    });
  }

  QueryBuilder<OpenHoursDay, OpenHoursDay, QAfterFilterCondition>
      startIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'start',
        value: '',
      ));
    });
  }
}

extension OpenHoursDayQueryObject
    on QueryBuilder<OpenHoursDay, OpenHoursDay, QFilterCondition> {}
