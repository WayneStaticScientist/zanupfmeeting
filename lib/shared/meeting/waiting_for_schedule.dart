import 'dart:async';
import 'dart:math' as math;
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';
import 'package:zanupfmeeting/shared/widgets/primary_button.dart';

class MeetingWaitingRoom extends StatefulWidget {
  final MeetingModel meeting;
  final VoidCallback onMeetingStarted;

  const MeetingWaitingRoom({
    super.key,
    required this.meeting,
    required this.onMeetingStarted,
  });

  @override
  State<MeetingWaitingRoom> createState() => _MeetingWaitingRoomState();
}

class _MeetingWaitingRoomState extends State<MeetingWaitingRoom>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  final _userController = Get.find<UserController>();
  Timer? _countdownTimer;
  Duration _timeLeft = Duration.zero;
  bool _isPastTime = false;
  bool _isRequestingToJoin = false;
  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _startCountdown();
  }

  void _startCountdown() {
    _calculateTime();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTime();
    });
  }

  void _calculateTime() {
    if (widget.meeting.scheduleTime == null) return;

    try {
      // Parse ISO8601 string - DateTime.parse handles the Z or offset correctly
      final scheduleDate = DateTime.parse(
        widget.meeting.scheduleTime!,
      ).toLocal();
      final now = DateTime.now();

      setState(() {
        _timeLeft = scheduleDate.difference(now);
        _isPastTime = _timeLeft.isNegative;
      });

      // If the meeting status changes to "Active" elsewhere,
      // the parent should handle navigation, but we check here too.
      if (_isPastTime && widget.meeting.status == "Active") {
        widget.onMeetingStarted();
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (_isPastTime) return "Starting soon...";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) return "$hours:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isInMeeting =
        widget.meeting.participants.indexWhere(
          (e) => e.userId == _userController.user.value!.id,
        ) >=
        0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow Effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [colorScheme.primary.withAlpha(40), Colors.black],
                  radius: 1.2,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  // Header Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.primary.withAlpha(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_clock_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "SCHEDULED SESSION",
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  14.gapHeight,
                  // Animated Visualizer
                  SizedBox(
                    height: 240,
                    width: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildRing(
                          1.0,
                          _rotationController,
                          colorScheme.primary,
                          1.5,
                        ),
                        _buildRing(
                          0.8,
                          _rotationController,
                          colorScheme.secondary,
                          1.0,
                          reverse: true,
                        ),
                        _buildRing(
                          0.6,
                          _rotationController,
                          colorScheme.primary.withAlpha(128),
                          0.5,
                        ),

                        // Center Pulse Icon
                        ScaleTransition(
                          scale: Tween(begin: 0.9, end: 1.1).animate(
                            CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withAlpha(128),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.videocam_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Meeting Details
                  Text(
                    widget.meeting.roomName,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),

                  PrimaryButton(
                    text: "Request To Join",
                    isLoading: _isRequestingToJoin,
                    onPressed: _requestToJoin,
                  ).visibleIfNot(isInMeeting),
                  Text(
                    "Hosted by ${widget.meeting.participants.firstOrNull?.displayName ?? ''}",
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Countdown Timer
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isPastTime ? "WAITING FOR HOST" : "STARTS IN",
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white38,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_timeLeft),
                          style: TextStyle(
                            color: _isPastTime
                                ? colorScheme.primary
                                : Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ).visibleIf(isInMeeting),

                  // Bottom Action / Status
                  Text(
                    "The meeting will begin automatically.",
                    style: textTheme.bodySmall?.copyWith(color: Colors.white24),
                    textAlign: TextAlign.center,
                  ).visibleIf(isInMeeting),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRing(
    double scale,
    Animation<double> animation,
    Color color,
    double strokeWidth, {
    bool reverse = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: (reverse ? -animation.value : animation.value) * 2 * math.pi,
            child: CustomPaint(
              size: const Size(240, 240),
              painter: _RingPainter(color: color, strokeWidth: strokeWidth),
            ),
          ),
        );
      },
    );
  }

  void _requestToJoin() async {
    setState(() {
      _isRequestingToJoin = true;
    });
    final response = await Net.post(
      "/meetings/room/participant-request",
      data: {
        "userId": _userController.user.value!.id,
        "meetingCode": widget.meeting.meetingCode,
      },
    );
    if (!mounted) return;
    setState(() {
      _isRequestingToJoin = false;
    });
    if (response.hasError) {
      return Toaster.error(response.response, title: "Joining Failure");
    }
    final md = MeetingModel.fromJson(response.body['meeting']);
    setState(() {
      widget.meeting.participants.clear();
      widget.meeting.participants.addAll(md.participants);
    });
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  _RingPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withAlpha(50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Main ring
    canvas.drawCircle(center, radius, paint);

    // Orbital dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, 0), 4, dotPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
