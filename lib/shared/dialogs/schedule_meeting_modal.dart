import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zanupfmeeting/shared/widgets/primary_button.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';

class ScheduleMeetingModal extends StatefulWidget {
  final Function(void Function()) setModalState;
  const ScheduleMeetingModal({super.key, required this.setModalState});

  @override
  State<ScheduleMeetingModal> createState() => _ScheduleMeetingModalState();
}

class _ScheduleMeetingModalState extends State<ScheduleMeetingModal> {
  final _roomNameController = TextEditingController();
  final _meetingController = Get.find<MeetingController>();

  bool _isPublic = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  // Durations in minutes
  final List<String> _durations = ["30min", "1hr", "1hr30mins", "2hr", "2hr+"];
  String _selectedDuration = "1hr";

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _buildPickerTheme(child!, context),
    );
    if (picked != null) {
      widget.setModalState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => _buildPickerTheme(child!, context),
    );
    if (picked != null) {
      widget.setModalState(() => _selectedTime = picked);
    }
  }

  Widget _buildPickerTheme(Widget child, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: Theme.of(context).colorScheme.primary),
      ),
      child: child,
    );
  }

  String _formatIso8601() {
    final combined = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    return combined.toIso8601String();
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              "Schedule Meeting",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 24),

            // Room Name
            TextField(
              controller: _roomNameController,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: "Meeting Title",
                hintText: "Enter room name...",
                prefixIcon: const Icon(Icons.edit_calendar_rounded),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date & Time Row
            Row(
              children: [
                Expanded(
                  child: _buildSelectorCard(
                    label: "Date",
                    value: DateFormat('EEE, MMM d').format(_selectedDate),
                    icon: Icons.calendar_today_rounded,
                    onTap: _pickDate,
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSelectorCard(
                    label: "Time",
                    value: _selectedTime.format(context),
                    icon: Icons.access_time_rounded,
                    onTap: _pickTime,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Duration Selection
            Text(
              "Duration",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _durations.map((mins) {
                  final isSelected = _selectedDuration == mins;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(mins),
                      selected: isSelected,
                      onSelected: (val) =>
                          widget.setModalState(() => _selectedDuration = mins),
                      selectedColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Privacy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Public Meeting",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Visible to everyone in the lobby",
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _isPublic,
                  onChanged: (val) =>
                      widget.setModalState(() => _isPublic = val),
                  activeThumbColor: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Button
            Obx(
              () => PrimaryButton(
                onPressed: () {
                  final isoDate = _formatIso8601();
                  _meetingController.scheduleMeeting(
                    roomName: _roomNameController.text.trim(),
                    isPublic: _isPublic,
                    date: isoDate,
                    duration: _selectedDuration,
                  );
                },
                text: "Confirm & Schedule",
                isLoading: _meetingController.creatingMeeting.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(128)),
          color: colorScheme.surfaceContainerHighest.withAlpha(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
