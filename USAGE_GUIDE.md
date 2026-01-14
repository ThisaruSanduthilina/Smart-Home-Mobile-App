# Risy App - Complete Usage Guide

## 🚀 Quick Start

1. **Launch the app** - See the animated splash screen
2. **Dashboard loads** - All controls appear in sections
3. **Switch theme** - Click sun/moon icon (top-right)
4. **Control devices** - Use any section below

---

## 📱 Dashboard Overview

```
┌─────────────────────────────────────────┐
│  🏠 Risy                    🌙 💬       │  ← App Bar
│  Smart Automation                       │
├─────────────────────────────────────────┤
│                                         │
│  ⚡ Power Control & Monitoring          │  ← Section 1
│  ┌───────────────────────────────────┐ │
│  │ Current: 0.00156 A                │ │
│  │ Power Outage: No                  │ │
│  │ [Chart showing current trends]    │ │
│  └───────────────────────────────────┘ │
│                                         │
│  🪟 Curtain Control                     │  ← Section 2
│  ┌───────────────────────────────────┐ │
│  │ State: CLOSED   Status: STOPPED   │ │
│  │ Position: 25%                     │ │
│  │ [========>          ] Slider      │ │
│  │ [Open]  [Stop]  [Close]           │ │
│  └───────────────────────────────────┘ │
│                                         │
│  💡 Light Control                       │  ← Section 3
│  ┌─────────┐  ┌─────────┐            │
│  │ LED1    │  │ LED2    │            │
│  │ 💡 ON   │  │ 💡 OFF  │            │
│  │  [✓]    │  │  [ ]    │            │
│  └─────────┘  └─────────┘            │
│  ┌─────────┐  ┌─────────┐            │
│  │ LED3    │  │ LED4    │            │
│  └─────────┘  └─────────┘            │
│                                         │
│  [All ON]        [All OFF]             │
│                                         │
│                              💬 Chat    │  ← Floating Button
└─────────────────────────────────────────┘
```

---

## 🎨 Theme Switching

### Dark Mode (Default)
```
🌙 Black background
⬛ Dark grey cards
⚪ White text
💚 Green accents
```

### Light Mode
```
☀️ Light grey background
⬜ White cards
⬛ Dark text
💚 Green accents
```

**Toggle**: Click the sun/moon icon in the top-right

---

## ⚡ Section 1: Power Control & Monitoring

### What You See:
- **Current Amps**: Real-time power consumption
- **Previous Amps**: Last recorded value
- **Last Updated**: Timestamp of last reading
- **Visual Chart**: Line graph showing trends
- **Power Outage Alert**: Red warning if detected

### Status Indicators:
| Status | Color | Meaning |
|--------|-------|---------|
| ✅ Normal | Green | Power flowing normally |
| ❌ Outage | Red | No power detected |

### Example Reading:
```
Current: 0.00156 A
Previous: 0.00512 A
Last Updated: 21:13
```

### Power Outage Alert:
When current drops below 0.001A, you'll see:
```
┌────────────────────────────────────┐
│ ⚠️  POWER OUTAGE DETECTED          │
│ No current detected                │
└────────────────────────────────────┘
```

---

## 🪟 Section 2: Curtain Control

### Controls Available:

#### State Display
Shows current curtain state:
- **OPEN** - Curtain is fully open
- **CLOSED** - Curtain is fully closed

#### Status Display
Shows current movement status:
- **STOPPED** - Not moving
- **MOVING** - Currently in motion

#### Position Slider
- Range: 0% (closed) to 100% (open)
- Drag slider to set exact position
- Shows current position percentage

#### Action Buttons:
```
[Open]   [Stop]   [Close]
 🟢       🟡       🔴
```

| Button | Action | Color |
|--------|--------|-------|
| Open | Opens curtain fully | Green |
| Stop | Stops current movement | Orange |
| Close | Closes curtain fully | Red |

### Usage Examples:

**Open Curtain**:
1. Click "Open" button
2. State changes to "OPEN"
3. Status shows "MOVING" then "STOPPED"

**Set Position**:
1. Drag slider to 50%
2. Curtain moves to 50% open
3. Stops automatically at position

**Stop Movement**:
1. Click "Stop" button
2. Status changes to "STOPPED"
3. Position freezes at current location

---

## 💡 Section 3: Light Control

### LED Control Cards

Each light has its own card showing:
- **Light Name**: LED1, LED2, etc.
- **Icon**: Lightbulb (colored when ON)
- **Status**: ON or OFF
- **Toggle Switch**: Control the light

### LED States:

#### Light ON
```
┌─────────────┐
│ 💚 LED1     │  ← Green bulb icon
│             │
│ LED1   [✓]  │  ← Green text, switch ON
│ ON          │  ← Green status
└─────────────┘
🟢 Green border
```

#### Light OFF
```
┌─────────────┐
│ ⚪ LED1     │  ← Grey bulb icon
│             │
│ LED1   [ ]  │  ← Normal text, switch OFF
│ OFF         │  ← Grey status
└─────────────┘
No border
```

### Available Lights:
1. **LED1** - Room light 1
2. **LED2** - Room light 2
3. **LED3** - Room light 3
4. **LED4** - Room light 4
5. **LOBBY LED1** - Lobby light 1
6. **LOBBY LED2** - Lobby light 2

### Quick Actions:

**All ON Button**:
- Click to turn on all lights instantly
- All cards get green borders
- All icons turn green
- All switches toggle to ON

**All OFF Button**:
- Click to turn off all lights instantly
- All borders disappear
- All icons turn grey
- All switches toggle to OFF

---

## 💬 Chat Control

### How to Access:
1. Click chat icon in app bar (top-right)
2. Click floating action button (bottom-right)

### Chat Interface:
```
┌─────────────────────────────────────────┐
│  🤖 Risy Assistant                  ←   │
│  Online                                 │
├─────────────────────────────────────────┤
│                                         │
│  Hello! I'm Risy...                    │  ← Bot message
│  Try saying:                           │
│  • "Turn on LED1"                      │
│                                         │
│              Turn on LED1  💬           │  ← Your message
│                                         │
│  Turned on LED1 ✓                      │  ← Bot response
│                                         │
├─────────────────────────────────────────┤
│ Type a command...              [Send]   │
└─────────────────────────────────────────┘
```

### Supported Commands:

#### Light Control:
```
"Turn on LED1"
"Turn off LED2"
"Switch on LOBBY LED1"
"Switch off LED4"
```

#### Curtain Control:
```
"Open curtain"
"Close curtain"
"Stop curtain"
"Stop the curtain"
```

#### Status Check:
```
"Power status"
"Check current"
"Status"
```

### Command Examples:

**Example 1: Turn on light**
```
You: Turn on LED1
Bot: Turned on LED1
```

**Example 2: Open curtain**
```
You: Open curtain
Bot: Opening curtain
```

**Example 3: Check power**
```
You: Power status
Bot: Current: 0.00156A
     Last updated: 21:13
```

**Example 4: Unknown command**
```
You: Make coffee
Bot: Sorry, I didn't understand that command.
     Try:
     - Turn on/off LED1-4
     - Open/close curtain
     - Check power status
```

---

## 🔄 Pull to Refresh

On the dashboard:
1. Pull down from top of screen
2. Release to refresh all data
3. All sections update with latest values

---

## 🎯 Tips & Tricks

### Best Practices:

1. **Use Sections**: Scroll to the section you need
2. **Quick Actions**: Use All ON/OFF for convenience
3. **Chat Control**: Type commands when hands-free
4. **Theme Switching**: Use dark mode at night
5. **Position Slider**: Set exact curtain position

### Keyboard Shortcuts (Chat):
- **Enter**: Send message
- **Backspace**: Delete text

### Visual Indicators:
- **Green Border**: Light is ON
- **Green Icon**: Active/ON state
- **Red Alert**: Power outage
- **Orange Badge**: Curtain moving

---

## 📊 Understanding Data

### Power Monitor:
- **0.00156 A** = Normal consumption
- **0.00000 A** = Power outage
- **Increasing trend** = Higher consumption
- **Decreasing trend** = Lower consumption

### Curtain Position:
- **0%** = Fully closed
- **50%** = Half open
- **100%** = Fully open

### Light Status:
- **ON (1)** = Light is on
- **OFF (0)** = Light is off

---

## ⚡ Real-Time Updates

All sections update automatically when:
- Hardware changes state
- Another user controls device
- Firebase database updates
- Network reconnects

**No need to refresh manually!**

---

## 🆘 Troubleshooting

### Issue: Can't switch theme
**Solution**: Make sure you're clicking the sun/moon icon in top-right

### Issue: Controls not working
**Solution**:
1. Check internet connection
2. Verify Firebase is accessible
3. Pull to refresh

### Issue: Power shows 0
**Solution**: This is normal if no devices are consuming power

### Issue: Curtain not responding
**Solution**:
1. Check hardware connection
2. Verify Firebase updates
3. Try Stop button first

### Issue: Chat not understanding
**Solution**:
- Use exact command format
- Check spelling
- Use examples from this guide

---

## 📱 App Navigation Flow

```
Splash Screen (3 seconds)
        ↓
Dashboard (Main screen)
        ├→ Section 1: Power Monitoring
        ├→ Section 2: Curtain Control
        ├→ Section 3: Light Control
        └→ Chat Screen (via button)
```

---

## 🎨 Color Guide

### Theme Colors:

**Primary (Green)**:
- Hex: `#00FF88`
- RGB: `0, 255, 136`
- Use: Accents, active states, buttons

**Status Colors**:
- ✅ Success: Green (#00FF88)
- ❌ Error: Red (#FF4444)
- ⚠️ Warning: Orange (#FFAA00)
- ℹ️ Info: Blue (#00AAFF)

---

## 🔐 Security Notes

- All data is synced with Firebase
- No local storage of credentials
- Real-time encryption via Firebase
- Secure HTTPS connections

---

## 📞 Support

If you need help:
1. Check this guide first
2. Review THEME_FEATURES.md
3. Check README.md
4. Open an issue on GitHub

---

**Enjoy using Risy!** 🏠✨

Your smart home automation companion with beautiful light & dark modes and organized sectioned controls!
