import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';
import 'package:zanupfmeeting/features/meeting/screens/conference_loader.dart';
import 'package:zanupfmeeting/shared/widgets/primary_button.dart';

class JoinMeetingModal extends StatefulWidget {
  final Function(void Function()) setModalState;
  const JoinMeetingModal({super.key, required this.setModalState});

  @override
  State<JoinMeetingModal> createState() => _JoinMeetingModalState();
}

class _JoinMeetingModalState extends State<JoinMeetingModal> {
  final _codeController = TextEditingController();
  final _meetingController = Get.find<MeetingController>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 16,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Text(
            "Join a Meeting",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter the code provided by the organizer to enter the room.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Code Input Field
          TextField(
            controller: _codeController,
            autofocus: true,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              // Automatically forces uppercase and removes spaces
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: InputDecoration(
              hintText: "ABC-123-XYZ",
              hintStyle: TextStyle(
                color: colorScheme.outlineVariant,
                letterSpacing: 1,
                fontSize: 20,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withBlue(90),
              prefixIcon: Icon(
                Icons.vpn_key_rounded,
                color: colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tip
          Center(
            child: Text(
              "Example: MEETING-123",
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
          ),
          const SizedBox(height: 32),

          // Join Button
          Obx(
            () => PrimaryButton(
              onPressed: () {
                if (_codeController.text.trim().length < 6) {
                  return Toaster.error("invalid meeting code");
                }
                Get.off(
                  () => MeetingSearchLoader(meetingCode: _codeController.text),
                );
              }, // Disabled if code is too short
              text: "Enter Room",
              isLoading: _meetingController
                  .creatingMeeting
                  .value, // Reusing loading state
            ),
          ),
        ],
      ),
    );
  }
}
