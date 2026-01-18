import 'package:flutter/foundation.dart';
import '../models/message_model.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  ChatProvider() {
    // Start with empty chat - welcome screen will be shown
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage.user(text));

    // Remove old suggestions
    _messages.removeWhere((msg) => msg.type == MessageType.suggestion);

    notifyListeners();

    // Show typing indicator
    _isTyping = true;
    notifyListeners();

    // Simulate bot response delay
    await Future.delayed(const Duration(milliseconds: 1500));

    _isTyping = false;

    // Add bot response based on user input
    String response = _getBotResponse(text);
    _messages.add(ChatMessage.bot(response));

    notifyListeners();
  }

  String _getBotResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('leg') ||
        lowerMessage.contains('sore') ||
        lowerMessage.contains('workout')) {
      return 'Got your Note! I will adjust the plan and select more intense exercises for the next workout!';
    } else if (lowerMessage.contains('harder') ||
               lowerMessage.contains('intense')) {
      return 'Great! I\'ll increase the intensity of your workouts. We\'ll focus on more challenging exercises.';
    } else if (lowerMessage.contains('training') ||
               lowerMessage.contains('enjoyed') ||
               lowerMessage.contains('great')) {
      return 'That\'s wonderful to hear! Keep up the great work. I\'m here to help you achieve your fitness goals.';
    } else if (lowerMessage.contains('tired') ||
               lowerMessage.contains('hard') ||
               lowerMessage.contains('simpler')) {
      return 'I understand. Let\'s adjust the workout to match your current energy levels. Rest is important too!';
    } else if (lowerMessage.contains('better') ||
               lowerMessage.contains('ok')) {
      return 'Thanks for the feedback! I\'ll keep optimizing your workout plan based on your progress.';
    } else {
      return 'I\'m listening! Tell me more about your training experience, and I\'ll help adjust your fitness plan accordingly.';
    }
  }

  void handleSuggestionTap(String suggestion) {
    sendMessage(suggestion);
  }

  void clearChat() {
    _messages.clear();
    _isTyping = false;
    notifyListeners();
  }

  void addVoiceMessage(String text) {
    sendMessage(text);
  }
}
