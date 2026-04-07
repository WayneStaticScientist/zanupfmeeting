import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _messageText = TextEditingController();
  final _liveMeetingController = Get.find<LiveMeetingController>();
  final ImagePicker _picker = ImagePicker();
  @override
  void dispose() {
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            onPressed: () {
              _showAttachmentPicker(context);
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: "Attach document",
          ),
          const SizedBox(width: 8),
          // Message Text Field
          Expanded(
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
                    _liveMeetingController.sendMessage(
                      _messageText.text.trim(),
                    );
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
          ),
        ],
      ),
    );
  }

  void _showAttachmentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Send Attachment",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                children: [
                  _attachmentOption(
                    Icons.image,
                    "Image",
                    Colors.purple,
                    () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image == null) return;
                      _liveMeetingController.uploadFile(image.path, 'image');
                    },
                  ),
                  _attachmentOption(
                    Icons.videocam,
                    "Video",
                    Colors.orange,
                    () async {
                      Navigator.pop(context);
                      final XFile? video = await _picker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      if (video == null) return;
                      _liveMeetingController.uploadFile(video.path, 'video');
                    },
                  ),
                  _attachmentOption(
                    Icons.picture_as_pdf,
                    "PDF",
                    Colors.red,
                    () async {
                      Navigator.pop(context);
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx', 'ppt', 'pptx'],
                      );
                      if (result == null || result.files.isEmpty) return;
                      _liveMeetingController.uploadFile(
                        result.files.first.path!,
                        'doc',
                      );
                    },
                  ),
                  _attachmentOption(
                    Icons.music_note,
                    "Audio",
                    Colors.blue,
                    () async {
                      Navigator.pop(context);
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav', 'opus', 'ogg', 'm4a'],
                      );
                      if (result == null || result.files.isEmpty) return;
                      _liveMeetingController.uploadFile(
                        result.files.first.path!,
                        'audio',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget builder for each attachment icon
  Widget _attachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withAlpha(60),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
