import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat_screen.dart';
import '../providers/chat_provider.dart';

class ChatbotFab extends StatefulWidget {
  const ChatbotFab({super.key});

  @override
  State<ChatbotFab> createState() => _ChatbotFabState();
}

class _ChatbotFabState extends State<ChatbotFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openChatbot() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ChatProvider(),
          child: const ChatScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 90,
      child: GestureDetector(
        onTap: _openChatbot,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Pulse ring effect
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green
                            .withValues(alpha: 0.3 * (2 - _pulseAnimation.value)),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Main button
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E3A8A),
                          Color(0xFF1E40AF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/RiseLogo.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.white,
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Online indicator dot
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00FF88),
                      border: Border.all(
                        color: const Color(0xFF0F1419),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF88).withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
