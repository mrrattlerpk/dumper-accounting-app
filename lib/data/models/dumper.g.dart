// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dumper.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDumperCollection on Isar {
  IsarCollection<Dumper> get dumpers => this.collection();
}

const DumperSchema = CollectionSchema(
  name: r'Dumper',
  id: -2829388796659029370,
  properties: {
    r'capacityTons': PropertySchema(
      id: 0,
      name: r'capacityTons',
      type: IsarType.double,
    ),
    r'chassisNumber': PropertySchema(
      id: 1,
      name: r'chassisNumber',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 2,
      name: r'color',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'engineNumber': PropertySchema(
      id: 4,
      name: r'engineNumber',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 5,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'model': PropertySchema(
      id: 6,
      name: r'model',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 8,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'registrationNumber': PropertySchema(
      id: 9,
      name: r'registrationNumber',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dumperEstimateSize,
  serialize: _dumperSerialize,
  deserialize: _dumperDeserialize,
  deserializeProp: _dumperDeserializeProp,
  idName: r'id',
  indexes: {
    r'registrationNumber': IndexSchema(
      id: 4923047649648640974,
      name: r'registrationNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'registrationNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'model': IndexSchema(
      id: 8229337662361542422,
      name: r'model',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'model',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dumperGetId,
  getLinks: _dumperGetLinks,
  attach: _dumperAttach,
  version: '3.1.0+1',
);

int _dumperEstimateSize(
  Dumper object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chassisNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.color;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.engineNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.model.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.registrationNumber.length * 3;
  return bytesCount;
}

void _dumperSerialize(
  Dumper object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.capacityTons);
  writer.writeString(offsets[1], object.chassisNumber);
  writer.writeString(offsets[2], object.color);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.engineNumber);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeString(offsets[6], object.model);
  writer.writeString(offsets[7], object.notes);
  writer.writeString(offsets[8], object.ownerName);
  writer.writeString(offsets[9], object.registrationNumber);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

Dumper _dumperDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Dumper();
  object.capacityTons = reader.readDoubleOrNull(offsets[0]);
  object.chassisNumber = reader.readStringOrNull(offsets[1]);
  object.color = reader.readStringOrNull(offsets[2]);
  object.createdAt = reader.readDateTimeOrNull(offsets[3]);
  object.engineNumber = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.isActive = reader.readBool(offsets[5]);
  object.model = reader.readString(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.ownerName = reader.readStringOrNull(offsets[8]);
  object.registrationNumber = reader.readString(offsets[9]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[10]);
  return object;
}

P _dumperDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dumperGetId(Dumper object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dumperGetLinks(Dumper object) {
  return [];
}

void _dumperAttach(IsarCollection<dynamic> col, Id id, Dumper object) {
  object.id = id;
}

extension DumperByIndex on IsarCollection<Dumper> {
  Future<Dumper?> getByRegistrationNumber(String registrationNumber) {
    return getByIndex(r'registrationNumber', [registrationNumber]);
  }

  Dumper? getByRegistrationNumberSync(String registrationNumber) {
    return getByIndexSync(r'registrationNumber', [registrationNumber]);
  }

  Future<bool> deleteByRegistrationNumber(String registrationNumber) {
    return deleteByIndex(r'registrationNumber', [registrationNumber]);
  }

  bool deleteByRegistrationNumberSync(String registrationNumber) {
    return deleteByIndexSync(r'registrationNumber', [registrationNumber]);
  }

  Future<List<Dumper?>> getAllByRegistrationNumber(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'registrationNumber', values);
  }

  List<Dumper?> getAllByRegistrationNumberSync(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'registrationNumber', values);
  }

  Future<int> deleteAllByRegistrationNumber(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'registrationNumber', values);
  }

  int deleteAllByRegistrationNumberSync(List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'registrationNumber', values);
  }

  Future<Id> putByRegistrationNumber(Dumper object) {
    return putByIndex(r'registrationNumber', object);
  }

  Id putByRegistrationNumberSync(Dumper object, {bool saveLinks = true}) {
    return putByIndexSync(r'registrationNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRegistrationNumber(List<Dumper> objects) {
    return putAllByIndex(r'registrationNumber', objects);
  }

  List<Id> putAllByRegistrationNumberSync(List<Dumper> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'registrationNumber', objects,
        saveLinks: saveLinks);
  }
}

extension DumperQueryWhereSort on QueryBuilder<Dumper, Dumper, QWhere> {
  QueryBuilder<Dumper, Dumper, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhere> anyModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'model'),
      );
    });
  }
}

extension DumperQueryWhere on QueryBuilder<Dumper, Dumper, QWhereClause> {
  QueryBuilder<Dumper, Dumper, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> idBetween(
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

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> registrationNumberEqualTo(
      String registrationNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'registrationNumber',
        value: [registrationNumber],
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> registrationNumberNotEqualTo(
      String registrationNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [],
              upper: [registrationNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [registrationNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [registrationNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [],
              upper: [registrationNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelEqualTo(String model) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'model',
        value: [model],
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelNotEqualTo(
      String model) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [],
              upper: [model],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [model],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [model],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [],
              upper: [model],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelGreaterThan(
    String model, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'model',
        lower: [model],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelLessThan(
    String model, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'model',
        lower: [],
        upper: [model],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelBetween(
    String lowerModel,
    String upperModel, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'model',
        lower: [lowerModel],
        includeLower: includeLower,
        upper: [upperModel],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelStartsWith(
      String ModelPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'model',
        lower: [ModelPrefix],
        upper: ['$ModelPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'model',
        value: [''],
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterWhereClause> modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'model',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'model',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'model',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'model',
              upper: [''],
            ));
      }
    });
  }
}

extension DumperQueryFilter on QueryBuilder<Dumper, Dumper, QFilterCondition> {
  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capacityTons',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capacityTons',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capacityTons',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capacityTons',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capacityTons',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> capacityTonsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capacityTons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chassisNumber',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chassisNumber',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chassisNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chassisNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> chassisNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      chassisNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'engineNumber',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'engineNumber',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engineNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'engineNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> engineNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> registrationNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> registrationNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registrationNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> registrationNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registrationNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition>
      registrationNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DumperQueryObject on QueryBuilder<Dumper, Dumper, QFilterCondition> {}

extension DumperQueryLinks on QueryBuilder<Dumper, Dumper, QFilterCondition> {}

extension DumperQuerySortBy on QueryBuilder<Dumper, Dumper, QSortBy> {
  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByCapacityTons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityTons', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByCapacityTonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityTons', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DumperQuerySortThenBy on QueryBuilder<Dumper, Dumper, QSortThenBy> {
  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByCapacityTons() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityTons', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByCapacityTonsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacityTons', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Dumper, Dumper, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DumperQueryWhereDistinct on QueryBuilder<Dumper, Dumper, QDistinct> {
  QueryBuilder<Dumper, Dumper, QDistinct> distinctByCapacityTons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacityTons');
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByChassisNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chassisNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByEngineNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engineNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByOwnerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByRegistrationNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registrationNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Dumper, Dumper, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DumperQueryProperty on QueryBuilder<Dumper, Dumper, QQueryProperty> {
  QueryBuilder<Dumper, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Dumper, double?, QQueryOperations> capacityTonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacityTons');
    });
  }

  QueryBuilder<Dumper, String?, QQueryOperations> chassisNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chassisNumber');
    });
  }

  QueryBuilder<Dumper, String?, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Dumper, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Dumper, String?, QQueryOperations> engineNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engineNumber');
    });
  }

  QueryBuilder<Dumper, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Dumper, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<Dumper, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Dumper, String?, QQueryOperations> ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<Dumper, String, QQueryOperations> registrationNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationNumber');
    });
  }

  QueryBuilder<Dumper, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
