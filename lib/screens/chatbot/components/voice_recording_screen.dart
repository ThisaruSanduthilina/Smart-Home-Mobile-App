import 'package:flutter/material.dart';
import 'dart:math' as math;

class VoiceRecordingScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onRecordingComplete;

  const VoiceRecordingScreen({
    super.key,
    required this.onClose,
    required this.onRecordingComplete,
  });

  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  bool _isListening = false;
  final String _displayText = 'PulseChat is listening...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Simulate listening
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isListening = true;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onClose,
        ),
        title: const Text(
          'PulseChat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated orb with gradient
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse rings
                          for (int i = 0; i < 3; i++)
                            _buildPulseRing(i),
                          // Main visualization area
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: _isListening
                                  ? _buildWaveAnimation()
                                  : _buildIdleAnimation(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  // Status text
                  Text(
                    _displayText,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (_isListening)
                    Text(
                      'Tap to stop',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Keyboard button
                  _buildActionButton(
                    icon: Icons.keyboard,
                    onTap: widget.onClose,
                  ),
                  // Main microphone button
                  GestureDetector(
                    onTap: _handleMicrophoneTap,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  // Camera button
                  _buildActionButton(
                    icon: Icons.photo_camera,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseRing(int index) {
    final delay = index * 0.3;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final value = (_pulseController.value - delay) % 1.0;
        final scale = 1.0 + (value * 0.5);
        final opacity = (1.0 - value) * 0.3;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green.withValues(alpha: opacity),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveAnimation() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: AudioWavePainter(_waveController.value, isListening: true),
        );
      },
    );
  }

  Widget _buildIdleAnimation() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: AudioWavePainter(0, isListening: false),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1F2937),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white70,
          size: 24,
        ),
      ),
    );
  }

  void _handleMicrophoneTap() {
    if (_isListening) {
      // Stop recording
      widget.onRecordingComplete(
          'Hi, I feel like my right leg is a little sore today, can you change your workout?');
      widget.onClose();
    } else {
      // Start recording
      setState(() {
        _isListening = true;
      });
    }
  }
}

class AudioWavePainter extends CustomPainter {
  final double animationValue;
  final bool isListening;

  AudioWavePainter(this.animationValue, {this.isListening = true});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw vertical bars like audio visualizer
    final barCount = 5;
    final barWidth = 8.0;
    final barSpacing = 12.0;
    final totalWidth = (barCount * barWidth) + ((barCount - 1) * barSpacing);
    final startX = center.dx - (totalWidth / 2);

    for (int i = 0; i < barCount; i++) {
      final x = startX + (i * (barWidth + barSpacing));

      if (!isListening) {
        // Idle state - show only dots
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(x + barWidth / 2, center.dy),
          barWidth / 2,
          dotPaint,
        );
      } else {
        // Listening state - animated bars growing from dots
        final barPhase = (animationValue * 2 * math.pi) + (i * 0.5);

        // Calculate bar height with variation
        double heightMultiplier;
        if (i == 2) {
          // Center bar - tallest
          heightMultiplier = 0.7 + (math.sin(barPhase * 2) * 0.3);
        } else if (i == 1 || i == 3) {
          // Middle bars
          heightMultiplier = 0.5 + (math.sin(barPhase * 1.8) * 0.3);
        } else {
          // Outer bars - shortest
          heightMultiplier = 0.3 + (math.sin(barPhase * 1.5) * 0.2);
        }

        final barHeight = 80 * heightMultiplier;

        final top = center.dy - (barHeight / 2);
        final bottom = center.dy + (barHeight / 2);

        // Draw the animated bar
        final barPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = barWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(x + barWidth / 2, top),
          Offset(x + barWidth / 2, bottom),
          barPaint,
        );

        // Draw dot on top of the bar (always visible in center)
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(x + barWidth / 2, center.dy),
          barWidth / 2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(AudioWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isListening != isListening;
  }
}
