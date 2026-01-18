# Chatbot Components Guide

## 🧩 Component Hierarchy

```
MainNavigation (with ChatbotFab)
    ↓ [Click FAB]
ChatScreen
    ├── AppBar (PulseChat title)
    ├── Message List
    │   ├── ChatBubble (User messages)
    │   ├── ChatBubble (Bot messages)
    │   ├── ChatBubble (Suggestions)
    │   └── TypingIndicator
    └── ChatInput
        ├── Voice Button → VoiceRecordingScreen
        └── Text Field with Send Button
```

## 📦 Component Details

### 1. ChatbotFab
**File**: `components/chatbot_fab.dart`

**Purpose**: Floating action button visible on all screens

**Features**:
- Animated pulse ring effect
- Green gradient background
- Online indicator dot
- Scale animation
- Opens ChatScreen on tap

**Position**: Bottom-right (20px from edges, 90px from bottom)

**Code Example**:
```dart
const ChatbotFab()
```

---

### 2. ChatScreen
**File**: `chat_screen.dart`

**Purpose**: Main chat interface container

**Features**:
- Dark background (`#0F1419`)
- App bar with title and menu
- Scrollable message list
- Chat input at bottom
- Provider integration

**Navigation**:
```dart
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

---

### 3. ChatBubble
**File**: `components/chat_bubble.dart`

**Purpose**: Individual message display

**Types**:
- **User Message**: Blue gradient, right-aligned
- **Bot Message**: Green gradient, left-aligned
- **Suggestion Chip**: Transparent, tappable

**Features**:
- Gradient backgrounds
- Avatar icons
- Name labels (You / PulseChat)
- Rounded corners (20px)
- Border and shadow

**Usage**:
```dart
ChatBubble(message: ChatMessage.user("Hello"))
ChatBubble(message: ChatMessage.bot("Hi there!"))
ChatBubble(message: ChatMessage.suggestion("Option"))
```

---

### 4. TypingIndicator
**File**: `components/typing_indicator.dart`

**Purpose**: Shows bot is typing

**Features**:
- 3 animated dots
- Opacity animation (0.3 → 1.0)
- 1500ms animation cycle
- Staggered timing (200ms delay per dot)
- Same style as bot message bubble

**Usage**:
```dart
if (chatProvider.isTyping) {
  const TypingIndicator()
}
```

---

### 5. ChatInput
**File**: `components/chat_input.dart`

**Purpose**: User input field with controls

**Features**:
- Text input field
- Voice button (left, green gradient)
- Send button (appears when typing)
- Mic icon (when empty)
- Optional attach button

**Callbacks**:
```dart
ChatInput(
  onSendMessage: (text) => sendMessage(text),
  onVoicePressed: () => openVoiceScreen(),
  onAttachPressed: () => attachFile(), // Optional
)
```

---

### 6. VoiceRecordingScreen
**File**: `components/voice_recording_screen.dart`

**Purpose**: Voice input interface

**Features**:
- Full screen modal
- Animated gradient orb (200px)
- 3 pulse rings
- Wave animation when listening
- Control buttons:
  - Keyboard (close)
  - Microphone (toggle record)
  - Camera (future feature)

**Animations**:
- Pulse rings: 2000ms repeat
- Wave bars: 1500ms repeat
- Orb gradient: 4 color stops

**Usage**:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VoiceRecordingScreen(
      onClose: () => Navigator.pop(context),
      onRecordingComplete: (text) {
        chatProvider.addVoiceMessage(text);
      },
    ),
  ),
);
```

---

## 🎨 Styling System

### Gradients

**User Message**:
```dart
LinearGradient(
  colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
)
```

**Bot Message**:
```dart
LinearGradient(
  colors: [Color(0xFF1F2937), Color(0xFF111827)],
)
```

**Voice Orb**:
```dart
RadialGradient(
  colors: [
    Color(0xFF4ADE80).withValues(alpha: 0.8),
    Color(0xFF22C55E).withValues(alpha: 0.9),
    Color(0xFF16A34A),
    Color(0xFF15803D),
  ],
)
```

**Green Buttons**:
```dart
LinearGradient(
  colors: [
    Colors.green.shade400,
    Colors.green.shade600,
  ],
)
```

### Borders

All cards and bubbles:
```dart
Border.all(
  color: Colors.white.withValues(alpha: 0.1),
  width: 1,
)
```

### Shadows

Standard shadow:
```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 10,
  offset: Offset(0, 4),
)
```

Glow shadow (buttons):
```dart
BoxShadow(
  color: Colors.green.withValues(alpha: 0.4),
  blurRadius: 20,
  offset: Offset(0, 4),
)
```

### Border Radius

- Cards: `20px`
- Input fields: `24px`
- Buttons: `Circle` or `12px`
- Suggestions: `20px`

## 🔧 State Management

### ChatProvider Methods

```dart
// Send a text message
chatProvider.sendMessage(String text)

// Handle suggestion tap
chatProvider.handleSuggestionTap(String text)

// Add voice message
chatProvider.addVoiceMessage(String text)

// Clear all messages
chatProvider.clearChat()
```

### ChatProvider Properties

```dart
// Get all messages
List<ChatMessage> messages = chatProvider.messages

// Check if bot is typing
bool isTyping = chatProvider.isTyping
```

## 📱 Responsive Behavior

- **Input**: Adapts to screen width
- **Bubbles**: Max width with margins (60px on opposite side)
- **FAB**: Fixed position, responsive to safe area
- **Voice Screen**: Full screen with safe area padding

## 🎯 Message Types

### User Message
```dart
ChatMessage.user("Your message here")
```

Properties:
- `type`: `MessageType.user`
- Right-aligned
- Blue gradient background
- "You" label with avatar

### Bot Message
```dart
ChatMessage.bot("Bot response here")
```

Properties:
- `type`: `MessageType.bot`
- Left-aligned
- Green gradient background
- "PulseChat" label with avatar

### Suggestion
```dart
ChatMessage.suggestion("Quick reply option")
```

Properties:
- `type`: `MessageType.suggestion`
- Chip style (rounded, transparent)
- Tappable
- Removed after first user message

### Typing Indicator
```dart
ChatMessage.typing()
```

Properties:
- `type`: `MessageType.bot`
- `isTyping`: `true`
- Shows animated dots

## 🔄 Animation Controllers

### TypingIndicator
- Duration: 1500ms
- Repeat: Infinite
- 3 dots with staggered delay (200ms)

### ChatbotFab
- Pulse: 2000ms repeat
- Scale: 0.95 → 1.05
- Pulse ring: 1.0 → 1.3 scale

### VoiceRecordingScreen
- Pulse controller: 2000ms repeat (3 rings)
- Wave controller: 1500ms repeat (12 bars)
- Smooth rotation and scaling

## 💡 Best Practices

1. **Provider Scope**: Create new ChatProvider for each chat session
2. **Message IDs**: Unique timestamps prevent duplicates
3. **Scroll Behavior**: Auto-scroll to bottom on new messages
4. **Memory**: Messages stored in memory only (add persistence if needed)
5. **Voice Input**: Currently simulated (integrate real STT if needed)

## 🎨 Customization Tips

### Change Greeting
Edit `chat_provider.dart`:
```dart
void _initializeChat() {
  _messages.add(
    ChatMessage.bot('Your custom greeting!'),
  );
}
```

### Add More Suggestions
```dart
_messages.add(ChatMessage.suggestion('New option'));
```

### Modify Bot Logic
```dart
String _getBotResponse(String userMessage) {
  // Your custom AI logic here
  return 'Custom response';
}
```

### Change Colors
Search for color values and replace:
- `0xFF4ADE80` → Your accent color
- `0xFF0F1419` → Your background
- `0xFF1F2937` → Your card color
