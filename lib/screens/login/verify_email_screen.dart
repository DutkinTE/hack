import 'package:hack/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // ignore: avoid_print
    print(isEmailVerified);

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));

      setState(() => canResendEmail = true);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomeScreen()
      : Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Image.asset(
          'lib/assets/images/iPhone 14 Pro Max - 14.png',
          width: double.infinity,
        ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                        const SizedBox(height: 220,),
                        const Center(
                        child: Text(
                          'We have sent you a confirmation email to your email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: canResendEmail ? sendVerificationEmail : null,
                        child: const SizedBox(
                        height: 56,
                        child: Center(
                            child: Text(
                          'SEND AGAIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter'
                          ),
                        ))),
                      ),
                      ],),
                      
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushNamed('/login'),
                            child: const Text(
                              'Сhange email',
                              style: TextStyle(
                                  color: Color.fromRGBO(129, 139, 160, 1),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  fontFamily: 'Inter'),
                            ),
                          ),
                          const SizedBox(height: 50,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}
