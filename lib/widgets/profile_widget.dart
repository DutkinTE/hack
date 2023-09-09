import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> signOut() async {
    final navigator = Navigator.of(context);
    setState(() {
      FirebaseAuth.instance.signOut();
      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  Future<void> delete() async {
    final navigator = Navigator.of(context);
    setState(() {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
      FirebaseAuth.instance.currentUser!.delete();
      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    onPressed: signOut,
                    child: const SizedBox(
                        height: 56,
                        child: Center(
                            child: Text(
                          'SING OUT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))),
                  ),
                  const SizedBox(height: 30,),
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
                    onPressed: delete,
                    child: const SizedBox(
                        height: 56,
                        child: Center(
                            child: Text(
                          'DELETE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))),
                  ),
          ],
        ),
      );
  }
}