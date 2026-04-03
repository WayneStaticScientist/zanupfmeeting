import 'dart:ui';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as live;
import 'package:zanupfmeeting/shared/meeting/meeting_error.dart';
import 'package:zanupfmeeting/shared/meeting/video_participant.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';
import 'package:zanupfmeeting/shared/widgets/meeting_loader.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class ScreenConferenceRoom extends StatefulWidget {
  final MeetingModel meetingModel;
  const ScreenConferenceRoom({super.key, required this.meetingModel});
  @override
  State<ScreenConferenceRoom> createState() => _ScreenConferenceRoomState();
}

class _ScreenConferenceRoomState extends State<ScreenConferenceRoom> {
  final _liveMeetingController = Get.find<LiveMeetingController>();
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _showSidebar = false;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _liveMeetingController.initMeeting(widget.meetingModel);
  }

  @override
  void dispose() {
    _liveMeetingController.closeMeeting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (_liveMeetingController.meetingError.value.isNotEmpty) {
          return MeetingErrorView(
            onRejoin: () {
              _liveMeetingController.closeMeeting();
              _liveMeetingController.initMeeting(widget.meetingModel);
            },
            errorMessage: _liveMeetingController.meetingError.value,
          );
        }
        if (_liveMeetingController.token.isEmpty) {
          return AnimatedMeetingLoader();
        }

        return Stack(
          children: [
            Positioned.fill(child: _buildVideoGrid(colorScheme)),
            _buildTopBar(colorScheme),
            _buildControlBar(colorScheme),
            if (_showSidebar) _buildSidePanel(colorScheme),
          ],
        );
      }),
    );
  }

  Widget _buildVideoGrid(ColorScheme colorScheme) {
    // Mocking 4 participants in a grid
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 80, _showSidebar ? 320 : 12, 100),
      child: Obx(() {
        if (_liveMeetingController.room.value == null) {
          return "Loading Meeting Settings".text().center();
        }
        final r = _liveMeetingController.room.value!;
        final meetings = [
          ...r.remoteParticipants.values,
          if (r.localParticipant != null) r.localParticipant!,
        ];

        return GridView.builder(
          itemCount: meetings.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getAxisCount(meetings.length, context),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 16 / 9,
          ),
          itemBuilder: (context, index) {
            final participant = meetings[index] as live.Participant;
            return VideoParticipant(
              participant: participant,
              key: ValueKey(participant.sid),
            );
          },
        );
      }),
    );
  }

  Widget _buildTopBar(ColorScheme colorScheme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withAlpha(210), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Strategy Session #402",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "12:45 • 24 Participants",
                    style: TextStyle(
                      color: Colors.white.withAlpha(140),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Meeting Request Notification Bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "1 Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar(ColorScheme colorScheme) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withAlpha(30)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _controlButton(
                      icon: _isMuted
                          ? Icons.mic_off_rounded
                          : Icons.mic_rounded,
                      color: _isMuted ? Colors.redAccent : Colors.white24,
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),
                    _controlButton(
                      icon: _isVideoOff
                          ? Icons.videocam_off_rounded
                          : Icons.videocam_rounded,
                      color: _isVideoOff ? Colors.redAccent : Colors.white24,
                      onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                    ),
                    _controlButton(
                      icon: Icons.screen_share_rounded,
                      color: Colors.white24,
                      onTap: () {},
                    ),
                    _controlButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: _showSidebar && _activeTab == 0
                          ? colorScheme.primary
                          : Colors.white24,
                      onTap: () => setState(() {
                        _showSidebar = !_showSidebar || _activeTab != 0;
                        _activeTab = 0;
                      }),
                    ),
                    _controlButton(
                      icon: Icons.people_outline_rounded,
                      color: _showSidebar && _activeTab == 1
                          ? colorScheme.primary
                          : Colors.white24,
                      onTap: () => setState(() {
                        _showSidebar = !_showSidebar || _activeTab != 1;
                        _activeTab = 1;
                      }),
                    ),
                    const SizedBox(width: 12),
                    _controlButton(
                      icon: Icons.call_end_rounded,
                      color: Colors.red,
                      isLarge: true,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    bool isLarge = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isLarge ? 56 : 48,
          height: isLarge ? 56 : 48,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: isLarge ? 28 : 22),
        ),
      ),
    );
  }

  Widget _buildSidePanel(ColorScheme colorScheme) {
    return Positioned(
      top: 100,
      right: 12,
      bottom: 100,
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(200),
              border: Border.all(color: Colors.white.withAlpha(30)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                // Tabs
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _tabItem(
                        "Chat",
                        _activeTab == 0,
                        () => setState(() => _activeTab = 0),
                        colorScheme,
                      ),
                      const SizedBox(width: 12),
                      _tabItem(
                        "People",
                        _activeTab == 1,
                        () => setState(() => _activeTab = 1),
                        colorScheme,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _activeTab == 0
                      ? _buildChatList()
                      : _buildParticipantList(),
                ),
                if (_activeTab == 0) _buildChatInput(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabItem(
    String title,
    bool active,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: active ? colorScheme.primary : Colors.white38,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Comrade $index",
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "The strategy for the next quarter looks solid.",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=$index'),
        ),
        title: Text(
          "Participant $index",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        trailing: const Icon(
          Icons.mic_none_rounded,
          color: Colors.white38,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildChatInput(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Send message...",
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: Colors.white.withAlpha(50),
          suffixIcon: Icon(Icons.send_rounded, color: colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  int getAxisCount(int length, BuildContext context) {
    if (length < 3) return 1;
    final width = MediaQuery.of(context).size.width;
    if (width < 800) {
      return 2;
    }
    if (length < 7) {
      return 3;
    }
    if (width < 1050) {
      return 3;
    }
    if (length < 13) {
      return 4;
    }
    if (width < 1300) {
      return 4;
    }
    return 5;
  }
}
