import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummy_Web_Key',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'riseoffice-22ca4',
    authDomain: 'riseoffice-22ca4.firebaseapp.com',
    databaseURL: 'https://riseoffice-22ca4-default-rtdb.firebaseio.com',
    storageBucket: 'riseoffice-22ca4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummy_Android_Key',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'riseoffice-22ca4',
    databaseURL: 'https://riseoffice-22ca4-default-rtdb.firebaseio.com',
    storageBucket: 'riseoffice-22ca4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummy_iOS_Key',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'riseoffice-22ca4',
    iosBundleId: 'com.risy.risy',
    databaseURL: 'https://riseoffice-22ca4-default-rtdb.firebaseio.com',
    storageBucket: 'riseoffice-22ca4.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummy_macOS_Key',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'riseoffice-22ca4',
    iosBundleId: 'com.risy.risy',
    databaseURL: 'https://riseoffice-22ca4-default-rtdb.firebaseio.com',
    storageBucket: 'riseoffice-22ca4.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDummy_Windows_Key',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'riseoffice-22ca4',
    authDomain: 'riseoffice-22ca4.firebaseapp.com',
    databaseURL: 'https://riseoffice-22ca4-default-rtdb.firebaseio.com',
    storageBucket: 'riseoffice-22ca4.appspot.com',
  );
}
