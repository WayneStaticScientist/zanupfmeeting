import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String userId, meetingCode, message, displayName;

  MessageModel({
    required this.userId,
    required this.meetingCode,
    required this.message,
    required this.displayName,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map toJosn() => _$MessageModelToJson(this);
}
