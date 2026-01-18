import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/message_model.dart';
import 'providers/chat_provider.dart';
import 'components/chat_bubble.dart';
import 'components/typing_indicator.dart';
import 'components/chat_input.dart';
import 'components/voice_recording_screen.dart';
import 'components/chat_welcome_screen.dart';
import 'components/chat_sidebar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _openVoiceRecording(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (newContext) => VoiceRecordingScreen(
          onClose: () => Navigator.of(newContext).pop(),
          onRecordingComplete: (text) {
            chatProvider.addVoiceMessage(text);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      drawer: const Drawer(
        child: ChatSidebar(),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        elevation: 0,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                // Show welcome screen if no messages
                if (chatProvider.messages.isEmpty && !chatProvider.isTyping) {
                  return ChatWelcomeScreen(
                    onSuggestionTap: (text) {
                      chatProvider.sendMessage(text);
                    },
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatProvider.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: TypingIndicator(),
                      );
                    }

                    final message = chatProvider.messages[index];

                    if (message.type == MessageType.suggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            chatProvider.handleSuggestionTap(message.text);
                          },
                          child: ChatBubble(message: message),
                        ),
                      );
                    }

                    return ChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          // Input area
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return ChatInput(
                onSendMessage: (text) {
                  chatProvider.sendMessage(text);
                },
                onVoicePressed: () {
                  _openVoiceRecording(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Clear Chat',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<ChatProvider>(context, listen: false)
                      .clearChat();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white70),
                title: const Text(
                  'About PulseChat',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          'About PulseChat',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'PulseChat features an integrated AI-powered chat that communicates with the user after each workout. It asks about your personalized feedback, then ensures every training session is perfectly tailored to your current condition.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
