import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/core/extensions/bool_utils.dart';
import 'package:zanupfmeeting/shared/meeting/meeting_participant.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class MeetingSidePanel extends StatefulWidget {
  final int activeTab;
  const MeetingSidePanel({super.key, required this.activeTab});

  @override
  State<MeetingSidePanel> createState() => _MeetingSidePanelState();
}

class _MeetingSidePanelState extends State<MeetingSidePanel> {
  int _activeTab = 0;
  final _messageText = TextEditingController();
  final _userController = Get.find<UserController>();
  final _liveMeetingController = Get.find<LiveMeetingController>();
  @override
  void initState() {
    _activeTab = widget.activeTab;
    super.initState();
  }

  @override
  void dispose() {
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                    _tabItem("Chat", _activeTab == 0, () {
                      _liveMeetingController.messagesSize.value = 0;
                      setState(() => _activeTab = 0);
                    }),
                    const SizedBox(width: 12),
                    _tabItem(
                      "People",
                      _activeTab == 1,
                      () => setState(() => _activeTab = 1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _activeTab == 0
                    ? _buildChatList()
                    : _buildParticipantList(),
              ),
              if (_activeTab == 0) _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem(String title, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: active
              ? Theme.of(context).colorScheme.primary
              : Colors.white38,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _liveMeetingController.messages.length,
        itemBuilder: (context, index) {
          final message = _liveMeetingController.messages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (_userController.user.value?.id == message.userId).lors(
                    "(you)",
                    (_liveMeetingController.meetingModel.value?.host ==
                            message.userId)
                        .lors(
                          "${message.displayName}(host)",
                          message.displayName,
                        ),
                  ),
                  style: TextStyle(
                    color:
                        (_liveMeetingController.meetingModel.value?.host ==
                                message.userId)
                            .lord(Colors.green, Colors.white60),
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
                  child: Text(
                    message.message,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticipantList() {
    return MeetingParticipant();
  }

  Widget _buildChatInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _messageText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Send message...",
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: Colors.white.withAlpha(50),
          suffixIcon: IconButton(
            onPressed: () {
              if (_messageText.text.trim().isEmpty) {
                return Toaster.error(
                  "Cant send empty message",
                  title: "Input Error",
                );
              }
              _liveMeetingController.sendMessage(_messageText.text.trim());
              setState(() {
                _messageText.text = "";
              });
            },
            icon: Icon(
              Icons.send_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
