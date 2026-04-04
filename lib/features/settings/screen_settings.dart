import 'package:flutter/material.dart';
import 'package:zanupfmeeting/shared/models/settings_model.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final settings = SettingsModel.fromStorage();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "MEETING SETTINGS",
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Glow (Matches Loader Design)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [colorScheme.primary.withAlpha(20), Colors.black],
                  radius: 1.5,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notifications",
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manage how alerts appear during your session.",
                    style: textTheme.bodySmall?.copyWith(color: Colors.white38),
                  ),
                  const SizedBox(height: 24),

                  // Block Message Notifications
                  _buildSettingsCard(
                    title: "Meeting Messages",
                    subtitle: "Hide alerts for new chat messages",
                    icon: Icons.chat_bubble_outline_rounded,
                    value: settings.disableMessageNotifications,
                    colorScheme: colorScheme,
                    onChanged: (val) {
                      settings.disableMessageNotifications = val;
                      settings.saveSettings();
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 16),

                  // Block Participant Joining
                  _buildSettingsCard(
                    title: "Participant Events",
                    subtitle: "Silence alerts when someone joins or leaves",
                    icon: Icons.person_add_disabled_rounded,
                    value: settings.disableParticipaantsNotifications,
                    colorScheme: colorScheme,
                    onChanged: (val) {
                      settings.disableParticipaantsNotifications = val;
                      settings.saveSettings();
                      setState(() {});
                    },
                  ),

                  const Spacer(),

                  // Footer Info
                  Center(
                    child: Text(
                      "Changes are applied instantly to your current session.",
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ColorScheme colorScheme,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: value
              ? colorScheme.primary.withAlpha(90)
              : Colors.white.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: value
                  ? colorScheme.primary.withAlpha(30)
                  : Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: value ? colorScheme.primary : Colors.white38,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
