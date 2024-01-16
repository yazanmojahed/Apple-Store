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
    apiKey: 'AIzaSyDJy-s8h1G2YD2ZLaUzqeXXmjr6B0AvOy4',
    appId: '1:357252770877:web:f262dd2e6a416246614e54',
    messagingSenderId: '357252770877',
    projectId: 'myfinalproject-ddc77',
    authDomain: 'myfinalproject-ddc77.firebaseapp.com',
    databaseURL: 'https://myfinalproject-ddc77-default-rtdb.firebaseio.com',
    storageBucket: 'myfinalproject-ddc77.appspot.com',
    measurementId: 'G-VY5NC3B22S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpFG2fEal20Ll6bUpqnLQCKB4uLxbxPVA',
    appId: '1:357252770877:android:48ff88786012c195614e54',
    messagingSenderId: '357252770877',
    projectId: 'myfinalproject-ddc77',
    databaseURL: 'https://myfinalproject-ddc77-default-rtdb.firebaseio.com',
    storageBucket: 'myfinalproject-ddc77.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQXAGf5A4gFub-z2xCF30HFRGimO58dtE',
    appId: '1:357252770877:ios:39605f29713fe8b7614e54',
    messagingSenderId: '357252770877',
    projectId: 'myfinalproject-ddc77',
    databaseURL: 'https://myfinalproject-ddc77-default-rtdb.firebaseio.com',
    storageBucket: 'myfinalproject-ddc77.appspot.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQXAGf5A4gFub-z2xCF30HFRGimO58dtE',
    appId: '1:357252770877:ios:2cba09b2f1d5a00a614e54',
    messagingSenderId: '357252770877',
    projectId: 'myfinalproject-ddc77',
    databaseURL: 'https://myfinalproject-ddc77-default-rtdb.firebaseio.com',
    storageBucket: 'myfinalproject-ddc77.appspot.com',
    iosBundleId: 'com.example.project.RunnerTests',
  );
}