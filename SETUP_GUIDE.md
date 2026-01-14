# Risy Setup Guide

## Quick Start Guide

### Step 1: Verify Prerequisites
Ensure you have the following installed:
- Flutter SDK 3.8.1+
- Android Studio or VS Code
- Git

Check Flutter installation:
```bash
flutter doctor
```

### Step 2: Install Dependencies
Navigate to the project folder and run:
```bash
cd risy
flutter pub get
```

### Step 3: Configure Firebase (Important!)

#### Option A: Use the Existing Firebase Database (Recommended for Testing)
The app is pre-configured with your Firebase database URL:
```
https://riseoffice-22ca4-default-rtdb.firebaseio.com/
```

**Note**: You need to update the Firebase API keys in `lib/firebase_options.dart` with your actual Firebase project keys.

#### Option B: Set Up Your Own Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing project
3. Enable Realtime Database
4. Set database rules (for testing, you can use public rules):
   ```json
   {
     "rules": {
       ".read": true,
       ".write": true
     }
   }
   ```
   **Warning**: These rules are insecure. Use authentication for production!

5. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

6. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```
   This will automatically generate `lib/firebase_options.dart` with secure keys.

### Step 4: Update Database Structure (if using new Firebase project)
Your Firebase Realtime Database should have this structure:
```json
{
  "LEDs": {
    "LED1": 0,
    "LED2": 0,
    "LED3": 0,
    "LED4": 0,
    "LOBBY_LED1": 0,
    "LOBBY_LED2": 0
  },
  "curtain": {
    "actual": 75,
    "cmd": "close",
    "position": 0,
    "state": "closed",
    "status": "stopped",
    "value": 25
  },
  "ct_monitor": {
    "current_amps": 0.00156,
    "last_updated": 7637859,
    "previous_amps": 0.00512
  }
}
```

### Step 5: Run the App

#### For Android Device/Emulator:
```bash
flutter run
```

#### For Web:
```bash
flutter run -d chrome
```

#### For iOS (Mac only):
```bash
flutter run -d ios
```

### Step 6: Build for Production

#### Android APK:
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

#### iOS (Mac only):
```bash
flutter build ios --release
```

## Testing the App

### Test Lighting Control
1. Open the app
2. Navigate to the dashboard
3. Toggle any LED switch
4. Verify the change in Firebase Console
5. Change value in Firebase Console and watch app update in real-time

### Test Curtain Control
1. Click "Open" button
2. Observe curtain state change
3. Use the slider to set position
4. Click "Stop" or "Close"

### Test Power Monitor
1. View current power consumption
2. Modify `current_amps` in Firebase to 0
3. Watch for power outage alert
4. Set it back to normal value

### Test Chat Control
1. Click chat icon or floating action button
2. Type: "Turn on LED1"
3. Verify LED1 turns on
4. Try: "Open curtain"
5. Try: "Check power status"

## Common Chat Commands

### Lighting
- "Turn on LED1"
- "Turn off LED2"
- "Switch on LOBBY LED1"
- "Switch off LED4"

### Curtains
- "Open curtain"
- "Close curtain"
- "Stop curtain"

### Status
- "Power status"
- "Check current"
- "Status"

## Troubleshooting

### Issue: Firebase Permission Denied
**Solution**: Update Firebase rules to allow read/write access:
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### Issue: App Not Connecting to Firebase
**Solution**:
1. Check internet connection
2. Verify database URL in `lib/firebase_options.dart`
3. Check Firebase Console for any issues

### Issue: Symlink Error on Windows
**Solution**:
1. Open Settings
2. Go to "Developer settings"
3. Enable "Developer Mode"
Or run: `start ms-settings:developers`

### Issue: Build Failed
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Hot Reload Not Working
**Solution**:
1. Save all files
2. Press `r` in terminal for hot reload
3. Press `R` for hot restart

## Hardware Integration

To connect real hardware (ESP32, Arduino, etc.):

1. Hardware reads sensors and controls devices
2. Hardware updates Firebase Realtime Database
3. App listens to database changes
4. App writes commands to database
5. Hardware listens for commands and executes

### Example ESP32 Code Structure (pseudo-code):
```cpp
// Read from Firebase
led1Status = firebase.getInt("LEDs/LED1");
digitalWrite(LED1_PIN, led1Status);

// Write to Firebase
currentAmps = readCurrentSensor();
firebase.setFloat("ct_monitor/current_amps", currentAmps);

// Listen for commands
if (firebase.getString("curtain/cmd") == "open") {
  openCurtain();
}
```

## Production Checklist

Before deploying to production:

- [ ] Update Firebase API keys with production keys
- [ ] Enable Firebase Authentication
- [ ] Set proper database security rules
- [ ] Test all features thoroughly
- [ ] Add error reporting (e.g., Firebase Crashlytics)
- [ ] Optimize images and assets
- [ ] Test on multiple devices
- [ ] Update app version in `pubspec.yaml`
- [ ] Create app icon and splash screen assets
- [ ] Test on slow network conditions
- [ ] Add analytics (optional)
- [ ] Create privacy policy
- [ ] Create terms of service

## Support

For issues:
1. Check this guide
2. Review README.md
3. Check Flutter documentation
4. Check Firebase documentation
5. Open an issue on GitHub

## Next Steps

After successful setup:
1. Customize the color theme in `lib/constants/colors.dart`
2. Add more LED controls if needed
3. Implement user authentication
4. Add scheduling features
5. Integrate with more devices
6. Add voice control (optional)
7. Create automation rules

---

Happy automating with Risy! 🏠✨
