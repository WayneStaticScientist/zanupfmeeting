// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String?,
  city: json['city'] as String?,
  password: json['password'] as String?,
  idNumber: json['idNumber'] as String?,
  chatToken: json['chatToken'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  email: json['email'] as String,
  role: json['role'] as String?,
  dateOfBirthday: json['dateOfBirthday'] as String?,
  lastName: json['lastName'] as String,
  firstName: json['firstName'] as String,
  phoneNumber: json['phoneNumber'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'password': instance.password,
  'phoneNumber': instance.phoneNumber,
  'roles': instance.roles,
  'dateOfBirthday': instance.dateOfBirthday,
  'idNumber': instance.idNumber,
  'city': instance.city,
  'role': instance.role,
  'chatToken': instance.chatToken,
};

const _$UserModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    '_id': {'type': 'string'},
    'email': {'type': 'string'},
    'firstName': {'type': 'string'},
    'lastName': {'type': 'string'},
    'password': {'type': 'string'},
    'phoneNumber': {'type': 'string'},
    'roles': {
      'type': 'array',
      'items': {'type': 'string'},
    },
    'dateOfBirthday': {'type': 'string'},
    'idNumber': {'type': 'string'},
    'city': {'type': 'string'},
    'role': {'type': 'string'},
    'chatToken': {'type': 'string'},
  },
  'required': ['email', 'firstName', 'lastName', 'phoneNumber', 'roles'],
};
