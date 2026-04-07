// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  userId: json['userId'] as String,
  meetingCode: json['meetingCode'] as String,
  message: json['message'] as String,
  displayName: json['displayName'] as String,
)..fileType = json['fileType'] as String?;

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'meetingCode': instance.meetingCode,
      'message': instance.message,
      'displayName': instance.displayName,
      'fileType': instance.fileType,
    };
