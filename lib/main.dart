import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leontech/features/auth/auth_middleware.dart';
import 'package:leontech/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leontech/theme.dart';
import 'core/services/fastscript.dart';
import 'core/utils/non_web_specific.dart' if (dart.library.html) 'core/utils/web_specific.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/userdata.dart';
import 'route.dart';
bool mainLoading = true;
const List<String> scopes = <String>[];
final googleSignIn = (kIsWeb)
    ? GoogleSignIn(
        clientId:
            "649322817470-0c163d2nebjfesbr4m4qobff4f609bo8.apps.googleusercontent.com",
        scopes: scopes)
    : GoogleSignIn(scopes: scopes);

void main() async {
  await FastScript.fetch();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  setupapp();// Menghilangkan # di URL
  if (!kIsWeb) FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
 
  
  if (!kIsWeb) {
    if (Platform.isWindows) {
      // sqfliteFfiInit();
      await GoogleSignInDart.register(
          clientId:
              '649322817470-ft18voe4493ijqfdoos2ugasnqtsh7m8.apps.googleusercontent.com');
    }
  }
   await cekLoagin();

  if (!kIsWeb) FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
       scrollBehavior: MyCustomScrollBehavior(),
       
      theme: theme2,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('id', 'ID'), // Bahasa Indonesia
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Lucky Jaya Group',
      getPages: rPage,
      initialRoute: '/',
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}