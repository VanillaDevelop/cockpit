import 'package:cockpit/config/configs.dart';
import 'package:cockpit/config/constants.dart';
import 'package:cockpit/firebase_options.dart';
import 'package:cockpit/pages/consciousness.dart';
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
        routes: {
          '/': (context) => const AuthGuard(),
          '/home': (context) => const HomePage(),
          '/thoughts': (context) => const ConsciousnessPage(),
        });
  }
}

class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return;
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction((context, state) {
          if (state is SignedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          }
        }),
      ],
    );
  }
}
