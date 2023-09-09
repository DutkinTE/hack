
import 'package:hack/screens/login/login_screen.dart';
import 'package:hack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Widget screen = const LoginScreen();

    (user == null) ? screen = const LoginScreen() : screen = const Screen();
    return screen;
  }
}


