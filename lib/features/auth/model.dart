import 'dart:convert';

import 'package:leontech/core/utils/function_string.dart';

class GoogleSignInAccountModel {
  String? id;
  String? email;
  String? displayName;
  String? photoUrl;
  int type;
  String? token;
  String? createdAt;

  // Constructor
  GoogleSignInAccountModel({
    this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.type = 3,
    this.token,
    this.createdAt,
  });
  factory GoogleSignInAccountModel.fromMap(Map<String, dynamic> json) {
    return GoogleSignInAccountModel(
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? json['photoURL'],
      type: makeInt(json['type'])??4,
      token: json['token'],
      createdAt: json['createdAt']?.toString(),
          
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'id': id,
      'email': email,
      'photoUrl': photoUrl,
      'type': type,
      'token': token,
      'createdAt': createdAt,
    };
  }

  factory GoogleSignInAccountModel.fromJson(String data) {
    return GoogleSignInAccountModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  // Method to convert the instance to JSON
  String toJson() => json.encode(toMap());
}

class AuthModel {
  bool isAuthorized;
  GoogleSignInAccountModel? user;
  GoogleSignInAccountModel? userfb;
  AuthModel({this.isAuthorized = false, this.user, this.userfb});
  factory AuthModel.fromMap(Map<String, dynamic> json) {
    return AuthModel(
      isAuthorized: makeBool(json['isAuthorized']) ?? false,
      user: (json['user'] == null)
          ? null
          : GoogleSignInAccountModel.fromMap(
              json['user'] as Map<String, dynamic>),
      userfb: (json['userfb'] == null)
          ? null
          : GoogleSignInAccountModel.fromMap(
              json['userfb'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'isAuthorized': isAuthorized,
      'user': user?.toMap(),
      'userfb': userfb?.toMap(),
    };
  }

  factory AuthModel.fromJson(String data) {
    return AuthModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}
