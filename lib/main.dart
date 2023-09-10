import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hack/scripts/firebase_api.dart';
import 'package:hack/widgets/create_screen.dart';
import 'package:hack/screens/home_screen.dart';
import 'package:hack/screens/login/firebase_stream.dart';
import 'package:hack/screens/login/login_screen.dart';
import 'package:hack/screens/login/reset_password.dart';
import 'package:hack/screens/login/signup_screen.dart';
import 'package:hack/screens/login/verify_email_screen.dart';
import 'package:hack/scripts/firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
    .then((_) {
      runApp(const MyApp()); 
      
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
        '/create': (context) => const CreateWidget()
      },
      initialRoute: '/',
    );
  }
}
