import 'package:cockpit/config/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase UI Auth Providers
final List<AuthProvider<AuthListener, auth.AuthCredential>> loginProviders = [
  GoogleProvider(
    clientId: dotenv.env['GOOGLE_CLIENT_ID']!,
  )
];

// Theme
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  useMaterial3: true,
);
