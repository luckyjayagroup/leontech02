import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/utils/userdata.dart';
import 'package:leontech/features/auth/model.dart';
import 'package:leontech/main.dart'; // Sesuaikan dengan path yang sesuai untuk data pengguna

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Jika userFB bernilai null (belum login), arahkan ke halaman login
    if (!auth.isAuthorized && !mainLoading) {
      if (Get.currentRoute != "/login") {
        dp("redirect /login");
        return const RouteSettings(name: '/login');
      }
    }
    // Jika sudah login, biarkan pengguna melanjutkan ke halaman yang dituju
    return null;
  }
}

cekLoagin() async {
  dp("cekLogin");
  auth = AuthModel();
  try {
    String? stringState = prefs.getString('state');
    if (stringState != null) {
      stringState = decryptData(stringState);
      auth = AuthModel.fromJson(stringState);
    }
  } catch (e, s) {
    dp("getLoagin\nerror: $e \nstacktrace: $s");
  }
  if (auth.isAuthorized && !mainLoading) {
    dp("!mainLoading ${!mainLoading}");
    if (Get.currentRoute != "/") Get.offAllNamed('/');
  } else {
    if (!kIsWeb && !io.Platform.isWindows) {
      dp("googleSignIn.signInSilently()");
      googleSignIn.signInSilently();
    }
  }

  dp("auth: ${auth.toJson()}");
  mainLoading = false;
  await listenGoogleSignIn();

  if (!kIsWeb && io.Platform.isWindows) {
    dp("googleSignIn.signInSilently() via Win");
    try {
      await googleSignIn.signInSilently();
    } catch (error) {
      dp("Error during Google Sign-In: $error");
    }
  }
}

listenGoogleSignIn() async {
  dp("listenGoogleSignIn");
  googleSignIn.onCurrentUserChanged
      .listen((GoogleSignInAccount? account) async {
    dp("trigger listenGoogleSignIn $account");
    auth.isAuthorized = account != null;
    if (kIsWeb && account != null) {
      auth.isAuthorized = await googleSignIn.canAccessScopes(scopes);
    }

    if (account != null) {
      await saveLogin(account);
    }
  });
}

saveLogin(GoogleSignInAccount account) async {
  dp("saveLogin($account)");
  await saveGoogleSignInAccount(account);
  try {
    final GoogleSignInAuthentication googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await authFB.signInWithCredential(credential);
    final user = userCredential.user;
    auth.isAuthorized = true;
    auth.userfb = await _emailToFirebase(user!);
    prefs.setString('state', encryptData(auth.toJson()));

    dp("prefssetString(state) : ${prefs.getString('state')} [verified]");
    if (Get.currentRoute != "/") Get.offAllNamed('/');
  } catch (e, s) {
    Get.snackbar("Error", e.toString());
    dp("saveLogin --------------------------------------");
    dp("error: $e");
    dp("stacktrace: $s");
    dp("saveLogin --------------------------------------");
  }
}

Future<GoogleSignInAccountModel?> _emailToFirebase(user) async {
  var temouseraktif =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
  final docSnapshot = await temouseraktif.get();
  GoogleSignInAccountModel? tempuserFB;
  if (!docSnapshot.exists) {
    dp('user is not registered, create new user data in Firestore');
    tempuserFB = GoogleSignInAccountModel(
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
      type: 3, // Default type for new user
      createdAt: DateTime.now().toString(),
    );
    await temouseraktif.set(tempuserFB.toMap());
  } else {
    final userData = docSnapshot.data();
    tempuserFB = GoogleSignInAccountModel.fromMap(userData!);
  }
  return tempuserFB;
}

Future<void> saveGoogleSignInAccount(
    GoogleSignInAccount googleSignInAccount) async {
  dp("saveGoogleSignInAccount");
  auth.user = GoogleSignInAccountModel(
    id: googleSignInAccount.id,
    email: googleSignInAccount.email,
    displayName: googleSignInAccount.displayName,
    photoUrl: googleSignInAccount.photoUrl,
  );
}

Future<void> handleSignIn() async {
  dp("handleSignIn");
  try {
    (kIsWeb)
        ? await googleSignIn.signInSilently()
        : await googleSignIn.signIn();
  } catch (error) {
    dp("Error during Google Sign-In: $error");
  }
}

Future<void> handleSignOut() async {
  dp("handleSignOut");
  if (await googleSignIn.isSignedIn()) await googleSignIn.disconnect();
  await authFB.signOut();
  prefs.remove('state');
  auth.user = null;
  auth.userfb = null;
  auth.isAuthorized = false;
  Get.offAllNamed('/login');
}
