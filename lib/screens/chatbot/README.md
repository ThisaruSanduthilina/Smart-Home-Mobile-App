# PulseChat - AI Fitness Assistant

A premium chatbot interface for the Smart Home app with modern design and smooth animations.

## 📁 Folder Structure

```
chatbot/
├── models/
│   └── message_model.dart          # Message data structure
├── providers/
│   └── chat_provider.dart          # State management
├── components/
│   ├── chat_bubble.dart            # Message bubble UI
│   ├── typing_indicator.dart       # Animated typing dots
│   ├── chat_input.dart             # Input field with voice
│   ├── voice_recording_screen.dart # Voice recording UI
│   └── chatbot_fab.dart           # Floating action button
├── chat_screen.dart                # Main chat screen
└── chatbot.dart                    # Exports file

## 🎨 Features

- **Chat Bubbles** - User and bot messages with gradient backgrounds
- **Typing Indicator** - Animated dots showing bot activity
- **Voice Recording** - Animated gradient orb with pulse effects
- **Floating Action Button** - Accessible from all screens
- **Suggestion Chips** - Quick reply options
- **Smooth Animations** - Professional UI transitions

## 🚀 Usage

### Import the Chatbot FAB

```dart
import 'package:risy/screens/chatbot/components/chatbot_fab.dart';

// Add to your screen's Stack
Stack(
  children: [
    YourContent(),
    const ChatbotFab(), // Floating button in bottom-right
  ],
)
```

### Direct Chat Screen Navigation

```dart
import 'package:risy/screens/chatbot/chatbot.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: const ChatScreen(),
    ),
  ),
);
```

## 🎨 Design System

### Colors
- Background: `#0F1419`
- Cards: `#1F2937` to `#111827` (gradients)
- Accent: Green (`#4ADE80` to `#15803D`)
- Borders: White with 10% opacity

### Components
- Border radius: 20px for cards, 24px for inputs
- Shadows: Multiple layers for depth
- Animations: 1500-2000ms duration
- Pulse effects for emphasis

## 💬 Chat Flow

1. User opens chat via FAB
2. Bot greets with personalized message
3. Suggestion chips appear for quick responses
4. User can type or use voice input
5. Bot responds with contextual messages
6. Voice recording shows animated orb

## 🔧 Customization

Edit `chat_provider.dart` to:
- Change initial greeting
- Modify suggestion options
- Customize bot responses
- Adjust typing delay

## 📱 Responsive Design

- Mobile-first approach
- Adapts to screen size
- Safe area handling
- Smooth scrolling
