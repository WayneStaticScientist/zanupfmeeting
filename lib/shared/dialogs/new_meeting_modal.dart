import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';

class NewMeetingModal extends StatefulWidget {
  final Function(void Function()) setModalState;
  const NewMeetingModal({super.key, required this.setModalState});

  @override
  State<NewMeetingModal> createState() => _NewMeetingModalState();
}

class _NewMeetingModalState extends State<NewMeetingModal> {
  bool _isPublic = false;
  final _roomNameController = TextEditingController();
  final _meetingController = Get.find<MeetingController>();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 32,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(210),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Create New Meeting",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Set up your room details to start collaborating.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Room Name Field
          TextField(
            controller: _roomNameController,
            decoration: InputDecoration(
              labelText: "Room Name",
              hintText: "e.g., Weekly Strategy Sync",
              prefixIcon: const Icon(Icons.meeting_room_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withAlpha(128),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Privacy Toggle
          Text(
            "Privacy Setting",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTypeToggle(
                  label: "Public",
                  icon: Icons.public_rounded,
                  isSelected: _isPublic,
                  colorScheme: colorScheme,
                  onTap: () => widget.setModalState(() => _isPublic = true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTypeToggle(
                  label: "Private",
                  icon: Icons.lock_outline_rounded,
                  isSelected: !_isPublic,
                  colorScheme: colorScheme,
                  onTap: () => widget.setModalState(() => _isPublic = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Create Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Launch Meeting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle({
    required String label,
    required IconData icon,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(100),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
