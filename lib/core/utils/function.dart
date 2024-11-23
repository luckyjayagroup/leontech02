import 'dart:async';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'package:mime/mime.dart';
String encryptData(String plainText, {String keyString = 'my32lengthsupersecretnooneknows1', String ivString = '8bytesiv12345678'}) {
  final key = encrypt.Key.fromUtf8(keyString);
  final iv = encrypt.IV.fromUtf8(ivString);

  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

String decryptData(String cipherText, {String keyString = 'my32lengthsupersecretnooneknows1', String ivString = '8bytesiv12345678'}) {
  final key = encrypt.Key.fromUtf8(keyString);
  final iv = encrypt.IV.fromUtf8(ivString);

  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final decrypted = encrypter.decrypt64(cipherText, iv: iv);
  return decrypted;
}

Future<String> getMimeType(File? file) async {
  var mimeType = lookupMimeType(file!.path);
  if (mimeType == null) {
    var dataHeader = await file.readAsBytes();
    mimeType = lookupMimeType(file.path, headerBytes: dataHeader);
  }
  return mimeType ?? 'application/octet-stream'; // MIME default jika tidak ditemukan
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}