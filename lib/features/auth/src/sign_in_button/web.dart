// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in_web/web_only.dart' as web;

import 'stub.dart';

/// Renders a web-only SIGN IN button.
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return web.renderButton(
      configuration: web.GSIButtonConfiguration(
    size: web.GSIButtonSize.large,
    theme: web.GSIButtonTheme.filledBlack,
    shape: web.GSIButtonShape.pill,
  ));
}
