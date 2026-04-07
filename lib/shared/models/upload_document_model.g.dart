// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_document_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetUploadDocumentModelCollection on Isar {
  IsarCollection<String, UploadDocumentModel> get uploadDocumentModels =>
      this.collection();
}

final UploadDocumentModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'UploadDocumentModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'uploader', type: IsarType.json),
      IsarPropertySchema(name: 'id', type: IsarType.string),
      IsarPropertySchema(name: 'fileType', type: IsarType.string),
      IsarPropertySchema(name: 'fileName', type: IsarType.string),
      IsarPropertySchema(name: 'filePath', type: IsarType.string),
      IsarPropertySchema(name: 'meetingCode', type: IsarType.string),
      IsarPropertySchema(name: 'localPath', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<String, UploadDocumentModel>(
    serialize: serializeUploadDocumentModel,
    deserialize: deserializeUploadDocumentModel,
    deserializeProperty: deserializeUploadDocumentModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeUploadDocumentModel(
  IsarWriter writer,
  UploadDocumentModel object,
) {
  IsarCore.writeString(writer, 1, isarJsonEncode(object.uploader));
  IsarCore.writeString(writer, 2, object.id);
  IsarCore.writeString(writer, 3, object.fileType);
  IsarCore.writeString(writer, 4, object.fileName);
  IsarCore.writeString(writer, 5, object.filePath);
  IsarCore.writeString(writer, 6, object.meetingCode);
  IsarCore.writeString(writer, 7, object.localPath);
  return Isar.fastHash(object.id);
}

@isarProtected
UploadDocumentModel deserializeUploadDocumentModel(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 2) ?? '';
  final String _fileType;
  _fileType = IsarCore.readString(reader, 3) ?? '';
  final String _fileName;
  _fileName = IsarCore.readString(reader, 4) ?? '';
  final String _filePath;
  _filePath = IsarCore.readString(reader, 5) ?? '';
  final String _meetingCode;
  _meetingCode = IsarCore.readString(reader, 6) ?? '';
  final object = UploadDocumentModel(
    id: _id,
    fileType: _fileType,
    fileName: _fileName,
    filePath: _filePath,
    meetingCode: _meetingCode,
  );
  object.uploader =
      isarJsonDecode(IsarCore.readString(reader, 1) ?? 'null') ?? null;
  object.localPath = IsarCore.readString(reader, 7) ?? '';
  return object;
}

@isarProtected
dynamic deserializeUploadDocumentModelProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return isarJsonDecode(IsarCore.readString(reader, 1) ?? 'null') ?? null;
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _UploadDocumentModelUpdate {
  bool call({
    required String id,
    String? fileType,
    String? fileName,
    String? filePath,
    String? meetingCode,
    String? localPath,
  });
}

class _UploadDocumentModelUpdateImpl implements _UploadDocumentModelUpdate {
  const _UploadDocumentModelUpdateImpl(this.collection);

  final IsarCollection<String, UploadDocumentModel> collection;

  @override
  bool call({
    required String id,
    Object? fileType = ignore,
    Object? fileName = ignore,
    Object? filePath = ignore,
    Object? meetingCode = ignore,
    Object? localPath = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (fileType != ignore) 3: fileType as String?,
            if (fileName != ignore) 4: fileName as String?,
            if (filePath != ignore) 5: filePath as String?,
            if (meetingCode != ignore) 6: meetingCode as String?,
            if (localPath != ignore) 7: localPath as String?,
          },
        ) >
        0;
  }
}

sealed class _UploadDocumentModelUpdateAll {
  int call({
    required List<String> id,
    String? fileType,
    String? fileName,
    String? filePath,
    String? meetingCode,
    String? localPath,
  });
}

class _UploadDocumentModelUpdateAllImpl
    implements _UploadDocumentModelUpdateAll {
  const _UploadDocumentModelUpdateAllImpl(this.collection);

  final IsarCollection<String, UploadDocumentModel> collection;

  @override
  int call({
    required List<String> id,
    Object? fileType = ignore,
    Object? fileName = ignore,
    Object? filePath = ignore,
    Object? meetingCode = ignore,
    Object? localPath = ignore,
  }) {
    return collection.updateProperties(id, {
      if (fileType != ignore) 3: fileType as String?,
      if (fileName != ignore) 4: fileName as String?,
      if (filePath != ignore) 5: filePath as String?,
      if (meetingCode != ignore) 6: meetingCode as String?,
      if (localPath != ignore) 7: localPath as String?,
    });
  }
}

extension UploadDocumentModelUpdate
    on IsarCollection<String, UploadDocumentModel> {
  _UploadDocumentModelUpdate get update => _UploadDocumentModelUpdateImpl(this);

  _UploadDocumentModelUpdateAll get updateAll =>
      _UploadDocumentModelUpdateAllImpl(this);
}

sealed class _UploadDocumentModelQueryUpdate {
  int call({
    String? fileType,
    String? fileName,
    String? filePath,
    String? meetingCode,
    String? localPath,
  });
}

class _UploadDocumentModelQueryUpdateImpl
    implements _UploadDocumentModelQueryUpdate {
  const _UploadDocumentModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<UploadDocumentModel> query;
  final int? limit;

  @override
  int call({
    Object? fileType = ignore,
    Object? fileName = ignore,
    Object? filePath = ignore,
    Object? meetingCode = ignore,
    Object? localPath = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (fileType != ignore) 3: fileType as String?,
      if (fileName != ignore) 4: fileName as String?,
      if (filePath != ignore) 5: filePath as String?,
      if (meetingCode != ignore) 6: meetingCode as String?,
      if (localPath != ignore) 7: localPath as String?,
    });
  }
}

extension UploadDocumentModelQueryUpdate on IsarQuery<UploadDocumentModel> {
  _UploadDocumentModelQueryUpdate get updateFirst =>
      _UploadDocumentModelQueryUpdateImpl(this, limit: 1);

  _UploadDocumentModelQueryUpdate get updateAll =>
      _UploadDocumentModelQueryUpdateImpl(this);
}

class _UploadDocumentModelQueryBuilderUpdateImpl
    implements _UploadDocumentModelQueryUpdate {
  const _UploadDocumentModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<UploadDocumentModel, UploadDocumentModel, QOperations>
  query;
  final int? limit;

  @override
  int call({
    Object? fileType = ignore,
    Object? fileName = ignore,
    Object? filePath = ignore,
    Object? meetingCode = ignore,
    Object? localPath = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (fileType != ignore) 3: fileType as String?,
        if (fileName != ignore) 4: fileName as String?,
        if (filePath != ignore) 5: filePath as String?,
        if (meetingCode != ignore) 6: meetingCode as String?,
        if (localPath != ignore) 7: localPath as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension UploadDocumentModelQueryBuilderUpdate
    on QueryBuilder<UploadDocumentModel, UploadDocumentModel, QOperations> {
  _UploadDocumentModelQueryUpdate get updateFirst =>
      _UploadDocumentModelQueryBuilderUpdateImpl(this, limit: 1);

  _UploadDocumentModelQueryUpdate get updateAll =>
      _UploadDocumentModelQueryBuilderUpdateImpl(this);
}

extension UploadDocumentModelQueryFilter
    on
        QueryBuilder<
          UploadDocumentModel,
          UploadDocumentModel,
          QFilterCondition
        > {
  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  meetingCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterFilterCondition>
  localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }
}

extension UploadDocumentModelQueryObject
    on
        QueryBuilder<
          UploadDocumentModel,
          UploadDocumentModel,
          QFilterCondition
        > {}

extension UploadDocumentModelQuerySortBy
    on QueryBuilder<UploadDocumentModel, UploadDocumentModel, QSortBy> {
  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByUploader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByUploaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFileType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFileTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFileNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByFilePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByMeetingCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByMeetingCodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  sortByLocalPathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension UploadDocumentModelQuerySortThenBy
    on QueryBuilder<UploadDocumentModel, UploadDocumentModel, QSortThenBy> {
  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByUploader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByUploaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFileType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFileTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFileNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByFilePathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByMeetingCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByMeetingCodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterSortBy>
  thenByLocalPathDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension UploadDocumentModelQueryWhereDistinct
    on QueryBuilder<UploadDocumentModel, UploadDocumentModel, QDistinct> {
  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByUploader() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByFileType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByMeetingCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UploadDocumentModel, UploadDocumentModel, QAfterDistinct>
  distinctByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }
}

extension UploadDocumentModelQueryProperty1
    on QueryBuilder<UploadDocumentModel, UploadDocumentModel, QProperty> {
  QueryBuilder<UploadDocumentModel, dynamic, QAfterProperty>
  uploaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty> fileTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty>
  meetingCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UploadDocumentModel, String, QAfterProperty>
  localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension UploadDocumentModelQueryProperty2<R>
    on QueryBuilder<UploadDocumentModel, R, QAfterProperty> {
  QueryBuilder<UploadDocumentModel, (R, dynamic), QAfterProperty>
  uploaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty>
  fileTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty>
  fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty>
  meetingCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UploadDocumentModel, (R, String), QAfterProperty>
  localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension UploadDocumentModelQueryProperty3<R1, R2>
    on QueryBuilder<UploadDocumentModel, (R1, R2), QAfterProperty> {
  QueryBuilder<UploadDocumentModel, (R1, R2, dynamic), QOperations>
  uploaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  fileTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  meetingCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UploadDocumentModel, (R1, R2, String), QOperations>
  localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}
