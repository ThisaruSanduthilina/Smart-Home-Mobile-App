import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<ChatMessage> _messages = [];

  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'You',
  );

  final ChatUser _bot = ChatUser(
    id: '2',
    firstName: 'Risy',
  );

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Hello! I\'m Risy, your smart home assistant. You can control your lights and curtains by chatting with me.\n\nTry saying:\n• "Turn on LED1"\n• "Open curtain"\n• "Check power status"',
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          user: _bot,
          createdAt: DateTime.now(),
          text: text,
        ),
      );
    });
  }

  Future<void> _onSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
    });

    // Show typing indicator
    final typingMessage = ChatMessage(
      user: _bot,
      createdAt: DateTime.now(),
      text: 'Processing...',
    );

    setState(() {
      _messages.insert(0, typingMessage);
    });

    // Process command
    try {
      final response = await _firebaseService.processCommand(message.text);

      setState(() {
        _messages.remove(typingMessage);
      });

      _addBotMessage(response);
    } catch (e) {
      setState(() {
        _messages.remove(typingMessage);
      });

      _addBotMessage('Sorry, I encountered an error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risy Assistant',
                  style: theme.textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                      ),
                ),
                Text(
                  'Online',
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: primaryColor,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: DashChat(
        currentUser: _user,
        messages: _messages,
        onSend: _onSend,
        messageOptions: MessageOptions(
          currentUserContainerColor: primaryColor,
          currentUserTextColor: Colors.black,
          containerColor: surfaceColor,
          textColor: onSurfaceColor,
          showTime: true,
          timeFormat: DateFormat('HH:mm'),
          borderRadius: 12,
          messagePadding: const EdgeInsets.all(12),
        ),
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: 'Type a command...',
            hintStyle: TextStyle(
              color: onSurfaceColor.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
          inputTextStyle: TextStyle(color: onSurfaceColor),
          sendButtonBuilder: (onSend) {
            return IconButton(
              icon: const Icon(Icons.send_rounded),
              color: primaryColor,
              iconSize: 28,
              onPressed: onSend,
            );
          },
        ),
        messageListOptions: MessageListOptions(
          showDateSeparator: true,
          dateSeparatorFormat: DateFormat('MMM dd, yyyy'),
          separatorFrequency: SeparatorFrequency.days,
        ),
      ),
    );
  }
}
