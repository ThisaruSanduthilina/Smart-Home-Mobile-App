enum MessageType {
  user,
  bot,
  suggestion,
}

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    this.isTyping = false,
  });

  factory ChatMessage.user(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.bot(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.suggestion(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.suggestion,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.typing() {
    return ChatMessage(
      id: 'typing',
      text: '',
      type: MessageType.bot,
      timestamp: DateTime.now(),
      isTyping: true,
    );
  }
}
