import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyAHpFbUU5GFoBDvJ21wiH_FpH9Zx-zgj1g',
    appId: '1:936911580884:web:8336532f2c073467fc9541',
    messagingSenderId: '936911580884',
    projectId: 'educonnect-69caf',
    authDomain: 'educonnect-69caf.firebaseapp.com',
    storageBucket: 'educonnect-69caf.firebasestorage.app',
    measurementId: 'G-R0325956E0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXRXhpa9GoQcxO9YxCoLJTfQggb8gA-0g',
    appId: '1:936911580884:android:03904bed6c246825fc9541',
    messagingSenderId: '936911580884',
    projectId: 'educonnect-69caf',
    storageBucket: 'educonnect-69caf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrjRk8XoSZm1uRfVChbUJaeWa62_1jUl0',
    appId: '1:936911580884:ios:03442a1cfc57b0cdfc9541',
    messagingSenderId: '936911580884',
    projectId: 'educonnect-69caf',
    storageBucket: 'educonnect-69caf.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCrjRk8XoSZm1uRfVChbUJaeWa62_1jUl0',
    appId: '1:936911580884:ios:03442a1cfc57b0cdfc9541',
    messagingSenderId: '936911580884',
    projectId: 'educonnect-69caf',
    storageBucket: 'educonnect-69caf.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHpFbUU5GFoBDvJ21wiH_FpH9Zx-zgj1g',
    appId: '1:936911580884:web:4882d5ac63049abbfc9541',
    messagingSenderId: '936911580884',
    projectId: 'educonnect-69caf',
    authDomain: 'educonnect-69caf.firebaseapp.com',
    storageBucket: 'educonnect-69caf.firebasestorage.app',
    measurementId: 'G-55L7LJTMF4',
  );
}
