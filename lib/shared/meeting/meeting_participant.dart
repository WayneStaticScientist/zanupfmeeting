import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as live;
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class MeetingParticipant extends StatefulWidget {
  const MeetingParticipant({super.key});

  @override
  State<MeetingParticipant> createState() => _MeetingParticipantState();
}

class _MeetingParticipantState extends State<MeetingParticipant> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveMeetingController>(
      builder: (controller) {
        if (controller.room.value == null) {
          return "Loading Meeting Settings".text().center();
        }
        final r = controller.room.value!;
        final meetings = [
          ...r.remoteParticipants.values,
          if (r.localParticipant != null) r.localParticipant!,
        ];
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final participant = meetings[index] as live.Participant;
            String name = participant.name.isEmpty ? "N" : participant.name;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 16, child: name[0].text()),
              title: Text(
                participant.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: Icon(
                !participant.isMuted
                    ? Icons.mic_outlined
                    : Icons.mic_off_outlined,
                color: participant.hasAudio ? Colors.red : Colors.white38,
                size: 18,
              ),
            );
          },
        );
      },
    );
  }
}
