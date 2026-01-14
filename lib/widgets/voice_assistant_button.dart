import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/firebase_service.dart';

class VoiceAssistantButton extends StatefulWidget {
  const VoiceAssistantButton({super.key});

  @override
  State<VoiceAssistantButton> createState() => _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends State<VoiceAssistantButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;
  final SpeechToText _speechToText = SpeechToText();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isListening = false;
  bool _isExpanded = false;
  String _recognizedText = '';
  String _responseText = '';

  @override
  void initState() {
    super.initState();

    // Scale animation for popup
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Wave animation for listening state
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _speechToText.initialize(
        onError: (error) {
          setState(() {
            _isListening = false;
          });
        },
      );
    }
  }

  void _startListening() async {
    if (!_speechToText.isAvailable) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _responseText = '';
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
    );

    // Auto-stop after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (_isListening) {
        _stopListening();
      }
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });

    if (_recognizedText.isNotEmpty) {
      _processCommand(_recognizedText);
    }
  }

  void _processCommand(String command) async {
    final response = await _firebaseService.processCommand(command);
    setState(() {
      _responseText = response;
    });

    // Show response for 3 seconds, then collapse
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _recognizedText = '';
          _responseText = '';
        });
      }
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text(
          'Please grant microphone permission to use voice commands.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _waveController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? 200 : 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Expanded content (when listening or showing response)
          if (_isExpanded)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isListening)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic,
                              color: Color(0xFF00AA55),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Listening...',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00AA55),
                              ),
                            ),
                          ],
                        ),
                      if (_recognizedText.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _recognizedText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (_responseText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _responseText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF00AA55),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // Voice button at bottom
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _scaleController.forward();
                  } else {
                    _scaleController.reverse();
                  }
                });

                if (_isExpanded && !_isListening) {
                  _startListening();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isListening ? 80 : 70,
                height: _isListening ? 80 : 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00BB55), // Darker green
                      Color(0xFF009944), // Darker green
                    ],
                  ),
                  borderRadius: BorderRadius.circular(_isListening ? 20 : 35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00AA55).withValues(alpha: 0.4),
                      blurRadius: _isListening ? 25 : 15,
                      spreadRadius: _isListening ? 5 : 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated waveform when listening
                    if (_isListening) ...[
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(60, 60),
                            painter: WaveformPainter(
                              animation: _waveController.value,
                            ),
                          );
                        },
                      ),
                    ] else
                      // Microphone icon when idle
                      const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 32,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animation;

  const WaveformPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final barWidth = 3.0;
    final spacing = 8.0;
    final bars = [
      // Left bars
      _BarData(-2 * (barWidth + spacing), 15),
      _BarData(-1 * (barWidth + spacing), 25),
      // Center bar
      _BarData(0, 35),
      // Right bars
      _BarData(1 * (barWidth + spacing), 25),
      _BarData(2 * (barWidth + spacing), 15),
    ];

    for (var bar in bars) {
      final phase = (animation + bar.x / 100) % 1.0;
      final height = bar.height * (0.3 + 0.7 * math.sin(phase * 2 * math.pi));

      canvas.drawLine(
        Offset(center.dx + bar.x, center.dy - height / 2),
        Offset(center.dx + bar.x, center.dy + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _BarData {
  final double x;
  final double height;

  _BarData(this.x, this.height);
}
