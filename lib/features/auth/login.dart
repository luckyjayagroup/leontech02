// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:leontech/core/utils/userdata.dart';

import 'auth_middleware.dart';
import 'src/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  ///
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isWindows= false;
  bool bybutton = false;
  var _isLoading = true;
  // ignore: unused_field


  @override
  void initState() {
    if (!kIsWeb){
      isWindows = Platform.isWindows;
    }
    super.initState();

    
     _isLoading = false;
  }


 


  Widget _buildBody() {
    if (auth.user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ListTile(
              leading: (auth.user!.photoUrl != null)
                  ? CircleAvatar(
                      radius: 20.0, // Avatar size (optional)
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: auth.user!.photoUrl ?? '',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : null,
              title: Text(auth.user?.displayName ?? ''),
              subtitle: Text(auth.user?.email ?? ''),
            ),
          ),
          const Text('Signed in successfully.'),
           ElevatedButton(
             onPressed: () async => await handleSignOut(),
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      // The user is NOT Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          buildSignInButton(
            onPressed: handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In 4'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}