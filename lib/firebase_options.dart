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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBtKOSuu2OG18jPoshAfIIHYJqwHRB49zI',
    appId: '1:726321130959:web:77f1c6e17a8f4c093676ba',
    messagingSenderId: '726321130959',
    projectId: 'petkubconnect',
    authDomain: 'petkubconnect.firebaseapp.com',
    storageBucket: 'petkubconnect.appspot.com',
    measurementId: 'G-6H6TYRP2LK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1DHA6OaMd4kFIuPFhM_Sb8jDr699U8So',
    appId: '1:726321130959:android:e171baea0d1f9cd53676ba',
    messagingSenderId: '726321130959',
    projectId: 'petkubconnect',
    storageBucket: 'petkubconnect.appspot.com',
  );
}