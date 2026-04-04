import 'dart:ui';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_client/livekit_client.dart' as live;
import 'package:zanupfmeeting/core/constants/meeting.dart';
import 'package:zanupfmeeting/core/extensions/bool_utils.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class VideoParticipant extends StatelessWidget {
  final live.Participant participant;
  final bool isHost;
  final String? focusNode;
  final bool hasFocus;
  final Function(String userId, String command) onCommand;
  const VideoParticipant({
    super.key,
    required this.participant,
    required this.isHost,
    required this.onCommand,
    this.focusNode,
    required this.hasFocus,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      builder: (context, childer) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: participant.isSpeaking
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              _buildVideoView(),
              Positioned(
                bottom: 12,
                left: 12,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: [
                        Icon(
                          !participant.isMuted
                              ? Icons.mic_outlined
                              : Icons.mic_off_rounded,
                          color: participant.hasAudio
                              ? Colors.redAccent
                              : Colors.grey,
                          size: 18,
                        ),
                        8.gapWidth,
                        Text(
                          participant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ].row(crossAxisAlignment: CrossAxisAlignment.center),
                    ),
                  ),
                ),
              ),
              // Mute status icon
              if (isHost)
                Positioned(
                  top: 12,
                  right: 12,
                  child: PopupMenuButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: (hasFocus ? 'Remove SpotLight' : 'SpotLight')
                              .text()
                              .textIconButton(
                                onPressed: () =>
                                    Get.find<LiveMeetingController>()
                                        .setSpotlight(
                                          !hasFocus
                                              ? participant.identity
                                              : null,
                                        ),
                                icon: Icon(
                                  hasFocus.lord(
                                    Icons.fullscreen_exit,
                                    Icons.fullscreen,
                                  ),
                                ),
                              ),
                        ),
                        PopupMenuItem(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: const Divider(),
                        ),
                        if (!participant.isMuted)
                          PopupMenuItem(
                            child: "Mute".text().textIconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onCommand(
                                  participant.identity,
                                  MeetingConstants.CMD_MUTE,
                                );
                              },
                              icon: Icon(Icons.mic_off),
                            ),
                          ),
                        PopupMenuItem(
                          child: "Video Off".text().textIconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onCommand(
                                participant.identity,
                                MeetingConstants.CMD_HIDE_CAMERA,
                              );
                            },
                            icon: Icon(Icons.camera_roll),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
            ],
          ),
        );
      },
      listenable: participant,
    );
  }

  Widget _buildVideoView() {
    final trackPub = participant.videoTrackPublications.firstOrNull;
    final isVideoMuted = trackPub?.muted ?? true;
    final track = trackPub?.track;

    if (track != null && track is VideoTrack && !isVideoMuted) {
      return VideoTrackRenderer(track);
    }
    return const Center(
      child: Icon(Icons.person, color: Colors.white, size: 48),
    );
  }
}
