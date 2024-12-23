// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBaV_PPavkfqs3ce2Wms832pz0bbrechRY',
    appId: '1:649322817470:web:d674585e85fd9a764dbbef',
    messagingSenderId: '649322817470',
    projectId: 'luckyjayagroupleontech',
    authDomain: 'luckyjayagroupleontech.firebaseapp.com',
    storageBucket: 'luckyjayagroupleontech.firebasestorage.app',
    measurementId: 'G-GTD5P6W99L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbraNEQqLCnJABz2HfYQsAkYo9TtUGB_8',
    appId: '1:649322817470:android:234494c9c96117cf4dbbef',
    messagingSenderId: '649322817470',
    projectId: 'luckyjayagroupleontech',
    storageBucket: 'luckyjayagroupleontech.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1jnGd13jZVuGqLstHg6DJMkraDRY1Z3M',
    appId: '1:649322817470:ios:c80f751f259f75d44dbbef',
    messagingSenderId: '649322817470',
    projectId: 'luckyjayagroupleontech',
    storageBucket: 'luckyjayagroupleontech.firebasestorage.app',
    iosBundleId: 'com.luckyjayagroup.leontech',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1jnGd13jZVuGqLstHg6DJMkraDRY1Z3M',
    appId: '1:649322817470:ios:c80f751f259f75d44dbbef',
    messagingSenderId: '649322817470',
    projectId: 'luckyjayagroupleontech',
    storageBucket: 'luckyjayagroupleontech.firebasestorage.app',
    iosBundleId: 'com.luckyjayagroup.leontech',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBaV_PPavkfqs3ce2Wms832pz0bbrechRY',
    appId: '1:649322817470:web:73f7228295f4d76c4dbbef',
    messagingSenderId: '649322817470',
    projectId: 'luckyjayagroupleontech',
    authDomain: 'luckyjayagroupleontech.firebaseapp.com',
    storageBucket: 'luckyjayagroupleontech.firebasestorage.app',
    measurementId: 'G-B7CYBXHMWG',
  );
}
