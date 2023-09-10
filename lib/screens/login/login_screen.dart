// ignore_for_file: use_build_context_synchronously

import 'package:hack/scripts/snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Wrong email or password. Try again',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Unknown error! Please try again or contact support.',
          true,
        );
        return;
      }
    }

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('lib/assets/images/iPhone 14 Pro Max - 14.png', width: double.infinity,),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 50.0, right: 30, left: 30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 130,
                      ),
                      const Center(
                          child: Text(
                        'Meeting N',
                        style: TextStyle(
                          color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 52),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(
                        height: 100,
                      ),
                      const Text(
                        'Email Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        autocorrect: false,
                        controller: emailTextInputController,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter correct Email'
                                : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white,),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Password',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autocorrect: false,
                        style: const TextStyle(color: Colors.white),
                        controller: passwordTextInputController,
                        obscureText: isHiddenPassword,
                        validator: (value) => value != null && value.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white,),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue,),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: login,
                        child: const SizedBox(
                            height: 56,
                            child: Center(
                                child: Text(
                              'SING IN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter'),
                            ))),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don’t have an account? ',
                            style: TextStyle(
                                color: Color.fromRGBO(129, 139, 160, 1),
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: 'Inter'),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/signup'),
                            child: const Text(
                              'Sign Up.',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/reset_password'),
                          child: const Text(
                            'Reset the password',
                            style: TextStyle(
                                color: Color.fromRGBO(129, 139, 160, 1),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: 'Inter'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
