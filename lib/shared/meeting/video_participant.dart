import 'dart:ui';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_client/livekit_client.dart' as live;

class VideoParticipant extends StatelessWidget {
  final live.Participant participant;
  final bool isHost;
  const VideoParticipant({
    super.key,
    required this.participant,
    required this.isHost,
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
                          child: "SpotLight".text().textIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.fullscreen),
                          ),
                        ),
                        PopupMenuItem(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: const Divider(),
                        ),
                        PopupMenuItem(
                          child: "Mute".text().textIconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mic_off),
                          ),
                        ),
                        PopupMenuItem(
                          child: "Video Off".text().textIconButton(
                            onPressed: () {},
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
