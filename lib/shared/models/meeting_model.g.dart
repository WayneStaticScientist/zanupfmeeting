// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
  public: json['public'] as bool,
  host: json['host'] as String,
  roomName: json['roomName'] as String,
  meetingCode: json['meetingCode'] as String,
  status: json['status'] as String,
  duration: json['duration'] as String?,
  scheduleTime: json['scheduleTime'] as String?,
  focuseNode: json['focuseNode'] as String?,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => Participant.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MeetingModelToJson(MeetingModel instance) =>
    <String, dynamic>{
      'public': instance.public,
      'host': instance.host,
      'roomName': instance.roomName,
      'meetingCode': instance.meetingCode,
      'status': instance.status,
      'duration': instance.duration,
      'scheduleTime': instance.scheduleTime,
      'focuseNode': instance.focuseNode,
      'participants': instance.participants,
    };

const _$MeetingModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'public': {'type': 'boolean'},
    'host': {'type': 'string'},
    'roomName': {'type': 'string'},
    'meetingCode': {'type': 'string'},
    'status': {'type': 'string'},
    'duration': {'type': 'string'},
    'scheduleTime': {'type': 'string'},
    'focuseNode': {'type': 'string'},
    'participants': {
      'type': 'array',
      'items': {r'$ref': r'#/$defs/Participant'},
    },
  },
  'required': [
    'public',
    'host',
    'roomName',
    'meetingCode',
    'status',
    'duration',
    'scheduleTime',
    'focuseNode',
    'participants',
  ],
  r'$defs': {
    'Participant': {
      'type': 'object',
      'properties': {
        'userId': {'type': 'string'},
        'role': {'type': 'string'},
        'displayName': {'type': 'string'},
        'status': {'type': 'string'},
      },
      'required': ['userId', 'role', 'displayName', 'status'],
    },
  },
};

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
  userId: json['userId'] as String,
  role: json['role'] as String,
  displayName: json['displayName'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'role': instance.role,
      'displayName': instance.displayName,
      'status': instance.status,
    };
