import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedMeetingLoader extends StatefulWidget {
  const AnimatedMeetingLoader({super.key});

  @override
  State<AnimatedMeetingLoader> createState() => _AnimatedMeetingLoaderState();
}

class _AnimatedMeetingLoaderState extends State<AnimatedMeetingLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  int _currentStep = 0;
  final List<String> _loadingSteps = [
    "Establishing secure connection...",
    "Syncing encryption keys...",
    "Optimizing video stream...",
    "Verifying room credentials...",
    "Finalizing workspace setup...",
  ];

  @override
  void initState() {
    super.initState();

    // Infinite rotation for the orbital rings
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Breathing pulse for the central icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Linear progress for the synchronous loading bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();

    _progressController.addListener(() {
      final newStep = (_progressController.value * _loadingSteps.length)
          .floor();
      if (newStep != _currentStep && newStep < _loadingSteps.length) {
        setState(() {
          _currentStep = newStep;
        });
      }
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to the conference room or show ready state
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          _buildBackgroundGlow(colorScheme),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Loader Visual
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildOrbitalRing(
                        0.8,
                        _rotationController,
                        colorScheme.primary,
                      ),
                      _buildOrbitalRing(
                        1.0,
                        _rotationController,
                        colorScheme.secondary,
                        reverse: true,
                      ),
                      _buildCentralPulse(colorScheme),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Text Status Area
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    key: ValueKey<int>(_currentStep),
                    children: [
                      Text(
                        "PREPARING ROOM",
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _loadingSteps[_currentStep],
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Synchronous Progress Bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [colorScheme.primary.withAlpha(35), Colors.black],
          radius: 0.8,
        ),
      ),
    );
  }

  Widget _buildOrbitalRing(
    double scale,
    Animation<double> animation,
    Color color, {
    bool reverse = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: reverse
                ? -animation.value * 2 * math.pi
                : animation.value * 2 * math.pi,
            child: CustomPaint(
              size: const Size(200, 200),
              painter: RingPainter(color: color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCentralPulse(ColorScheme colorScheme) {
    return ScaleTransition(
      scale: Tween(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(30),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(60),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          Icons.videocam_rounded,
          color: colorScheme.primary,
          size: 48,
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final Color color;
  RingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // Draw an orbital dot
    canvas.drawCircle(Offset(size.width / 2, 0), 4, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
