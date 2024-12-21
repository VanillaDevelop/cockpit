import 'package:cockpit/config/configs.dart';
import 'package:cockpit/config/constants.dart';
import 'package:cockpit/firebase_options.dart';
import 'package:cockpit/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders(loginProviders);

  runApp(const CockpitApp());
}

class CockpitApp extends StatelessWidget {
  const CockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginRedirect(),
    );
  }
}

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const SignInScreen();
      },
    );
  }
}
