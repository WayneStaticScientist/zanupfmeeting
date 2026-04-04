import 'package:json_annotation/json_annotation.dart';
part 'meeting_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class MeetingModel {
  static const statuses = ["Active", "Waiting", "Ended", "Scheduled"];
  final bool public;
  final String host, roomName, meetingCode, status;
  final String? duration, scheduleTime;
  String? focuseNode;
  final List<Participant> participants;
  MeetingModel({
    required this.public,
    required this.host,
    required this.roomName,
    required this.meetingCode,
    required this.status,
    required this.duration,
    required this.scheduleTime,
    required this.focuseNode,
    required this.participants,
  });
  factory MeetingModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingModelToJson(this);
}

@JsonSerializable()
class Participant {
  static const statuses = ["pending", "accepted", "rejected"];
  final String userId, role, displayName, status;
  Participant({
    required this.userId,
    required this.role,
    required this.displayName,
    required this.status,
  });
  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
  Map<String, Object> get schema => _$MeetingModelJsonSchema;
}
