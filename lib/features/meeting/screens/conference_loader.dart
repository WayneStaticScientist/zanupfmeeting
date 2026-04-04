import 'dart:math' as math;
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/features/meeting/screens/conference_room.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';

class MeetingSearchLoader extends StatefulWidget {
  final String meetingCode;

  const MeetingSearchLoader({super.key, required this.meetingCode});

  @override
  State<MeetingSearchLoader> createState() => _MeetingSearchLoaderState();
}

class _MeetingSearchLoaderState extends State<MeetingSearchLoader>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late AnimationController _rotationController;

  int _currentStep = 0;
  final List<String> _searchSteps = [
    "Locating room...",
    "Validating access code...",
    "Checking permissions...",
    "Joining session...",
  ];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Cycle through text steps
    _startTextCycle();

    WidgetsBinding.instance.addPostFrameCallback((e) {
      _reload();
    });
  }

  void _startTextCycle() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() {
        if (_currentStep < _searchSteps.length - 1) {
          _currentStep++;
        }
      });
      return _currentStep < _searchSteps.length - 1;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Tech Grid / Glow
          Positioned.fill(child: _buildBackground(colorScheme)),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Animated Code Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: colorScheme.primary.withAlpha(90),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tag, color: Colors.white54, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          widget.meetingCode.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  errorMessage
                      .text(style: TextStyle(color: Colors.red))
                      .margin(EdgeInsets.symmetric(vertical: 30))
                      .visibleIf(errorMessage.isNotEmpty),
                  const Spacer(),
                  // Central Scanning Visual
                  SizedBox(
                    height: 280,
                    width: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rotating Outer Ring
                        RotationTransition(
                          turns: _rotationController,
                          child: CustomPaint(
                            size: const Size(280, 280),
                            painter: _ScannerPainter(
                              color: colorScheme.primary,
                              progress: _scanController.value,
                            ),
                          ),
                        ),

                        // Pulsing Core
                        ScaleTransition(
                          scale: Tween(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withAlpha(60),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withAlpha(128),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).visibleIf(errorMessage.isEmpty),
                  const Spacer(),

                  // Status Text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      key: ValueKey<int>(_currentStep),
                      children: [
                        Text(
                          _searchSteps[_currentStep].toUpperCase(),
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Please wait a moment...",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ).visibleIf(errorMessage.isEmpty),
                  const SizedBox(height: 60),
                  TextButton(
                    onPressed: _reload,
                    child: Text("Reload", style: TextStyle()),
                  ).visibleIf(errorMessage.isNotEmpty),
                  const SizedBox(height: 40).visibleIf(errorMessage.isNotEmpty),
                ],
              ),
            ),
          ),
        ],
      ).sizedBox(width: double.infinity),
    );
  }

  Widget _buildBackground(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [colorScheme.primary.withAlpha(30), Colors.black],
          radius: 1.5,
        ),
      ),
      child: CustomPaint(
        painter: _GridPainter(color: colorScheme.primary.withAlpha(20)),
      ),
    );
  }

  _reload() async {
    if (!mounted) return;
    setState(() {
      errorMessage = '';
    });
    final response = await Net.get("/meetings/room/${widget.meetingCode}");
    if (!mounted) return;
    if (response.hasError) {
      setState(() {
        errorMessage = response.response;
      });
      return;
    }
    Get.off(
      () => ScreenConferenceRoom(
        meetingModel: MeetingModel.fromJson(response.body['meeting']),
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  final Color color;
  final double progress;

  _ScannerPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withAlpha(90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw static rings
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius - 40, paint);

    // Draw scanning arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi / 2,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
