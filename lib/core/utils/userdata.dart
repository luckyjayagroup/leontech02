
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leontech/core/models/user.dart';
import 'package:leontech/features/auth/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
AuthModel auth = AuthModel(isAuthorized: false);
final FirebaseAuth authFB = FirebaseAuth.instance;
USER? userAktif;
User? user;

getidLokasi()=> 1;
getidKontak()=> 1;
iSales() => true;
var iddevisi = 1;