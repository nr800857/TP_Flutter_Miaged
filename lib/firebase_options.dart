// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDmStotr4MRBlJp2HV7SSleBC0K2mHZiJk',
    appId: '1:1057575457490:web:ee8919773a89a43bb0930b',
    messagingSenderId: '1057575457490',
    projectId: 'tp-miaged-c1e57',
    authDomain: 'tp-miaged-c1e57.firebaseapp.com',
    storageBucket: 'tp-miaged-c1e57.appspot.com',
    measurementId: 'G-W36LE113J3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD66pJqiwzpkpTQGI-haEGub6v0vYydFXw',
    appId: '1:1057575457490:android:bc8f3bb25ebe75bab0930b',
    messagingSenderId: '1057575457490',
    projectId: 'tp-miaged-c1e57',
    storageBucket: 'tp-miaged-c1e57.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPHj60wRCTT3vHU9UlIzrK8BMHggHGik8',
    appId: '1:1057575457490:ios:395a6472a5061894b0930b',
    messagingSenderId: '1057575457490',
    projectId: 'tp-miaged-c1e57',
    storageBucket: 'tp-miaged-c1e57.appspot.com',
    iosClientId: '1057575457490-j7cck8pnkn46s6fachg28qd58ortmgma.apps.googleusercontent.com',
    iosBundleId: 'com.example.miaged',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPHj60wRCTT3vHU9UlIzrK8BMHggHGik8',
    appId: '1:1057575457490:ios:395a6472a5061894b0930b',
    messagingSenderId: '1057575457490',
    projectId: 'tp-miaged-c1e57',
    storageBucket: 'tp-miaged-c1e57.appspot.com',
    iosClientId: '1057575457490-j7cck8pnkn46s6fachg28qd58ortmgma.apps.googleusercontent.com',
    iosBundleId: 'com.example.miaged',
  );
}
