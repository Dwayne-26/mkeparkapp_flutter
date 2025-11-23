// Firebase configuration generated via flutterfire (placeholder values already present).

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        return linux;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBP62y78YixKuaIBiPJbEoXSSfYS5eAjoc',
    appId: '1:418926446148:web:c95f97e4dc542b4e631e11',
    messagingSenderId: '418926446148',
    projectId: 'mkeparkapp-1ad15',
    authDomain: 'mkeparkapp-1ad15.firebaseapp.com',
    storageBucket: 'mkeparkapp-1ad15.firebasestorage.app',
    measurementId: 'G-3SX1X1893N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaT4ZkDKVhwjiFwYCEhhf8c1Sd0xvnf_g',
    appId: '1:418926446148:android:5b40f8cb8fa408fa631e11',
    messagingSenderId: '418926446148',
    projectId: 'mkeparkapp-1ad15',
    storageBucket: 'mkeparkapp-1ad15.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-I3Fa-4bmR-rB-jngHkgWQnjTTHTBZDo',
    appId: '1:418926446148:ios:ebfafa1c09f2c91d631e11',
    messagingSenderId: '418926446148',
    projectId: 'mkeparkapp-1ad15',
    storageBucket: 'mkeparkapp-1ad15.firebasestorage.app',
    iosBundleId: 'com.mkeparkapp.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-I3Fa-4bmR-rB-jngHkgWQnjTTHTBZDo',
    appId: '1:418926446148:ios:8399796e128b9c2e631e11',
    messagingSenderId: '418926446148',
    projectId: 'mkeparkapp-1ad15',
    storageBucket: 'mkeparkapp-1ad15.firebasestorage.app',
    iosBundleId: 'com.example.MKEParkFlutterWeb',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBP62y78YixKuaIBiPJbEoXSSfYS5eAjoc',
    appId: '1:418926446148:web:2b8a98d004ddc463631e11',
    messagingSenderId: '418926446148',
    projectId: 'mkeparkapp-1ad15',
    authDomain: 'mkeparkapp-1ad15.firebaseapp.com',
    storageBucket: 'mkeparkapp-1ad15.firebasestorage.app',
    measurementId: 'G-9B6KY8MSY8',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'REPLACE_WITH_LINUX_API_KEY',
    appId: 'REPLACE_WITH_LINUX_APP_ID',
    messagingSenderId: 'REPLACE_WITH_MESSAGING_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_STORAGE_BUCKET',
  );
}
