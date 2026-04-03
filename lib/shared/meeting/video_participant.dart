import 'dart:ui';

import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_client/livekit_client.dart' as live;

class VideoParticipant extends StatelessWidget {
  final live.Participant participant;
  const VideoParticipant({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              final track =
                  participant.videoTrackPublications.firstOrNull?.track;
              if (track != null && track is VideoTrack) {
                return VideoTrackRenderer(
                  track,
                ); // This renders the actual stream
              }
              return Container(
                color: Colors.black,
                child: Icon(Icons.person, color: Colors.white),
              );
            },
          ).center(),
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
                  child: Text(
                    participant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Mute status icon
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.mic_off_rounded,
              color: Colors.redAccent,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
