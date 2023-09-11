import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen(
      {super.key,
      required this.func,
      required this.desc,
      required this.number,
      required this.time,
      required this.place,
      required this.email,
      required this.email2,
      required this.uid,
      required this.uid2});
    final String func;
  final String desc;
  final String number;
  final String email;
  final String email2;
  final String time;
  final String place;
  final String uid;
  final String uid2;
  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  @override
  Widget build(BuildContext context) {

    Future accept() async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      final navigator = Navigator.of(context);
      if (widget.func == 'ACCEPT'){
      if (widget.uid != user?.uid) {
        await firebaseFirestore.collection('users').doc(user?.uid).collection('my_meets').doc(widget.uid).set({
          'desc': widget.desc,
          'number': widget.number,
          'time': widget.time,
          'place': widget.place,
          'uid': widget.uid,
          'uid2': user?.uid,
          'email': widget.email,
          'email2': user?.email
        });

        await firebaseFirestore.collection('users').doc(widget.uid).collection('my_meets').doc(widget.uid).set({
          'desc': widget.desc,
          'number': widget.number,
          'time': widget.time,
          'place': widget.place,
          'uid': widget.uid,
          'uid2': user?.uid,
          'email': widget.email,
          'email2': user?.email
        });

        await firebaseFirestore.collection('public').doc(widget.uid).delete();
      }} else {
      if (widget.uid == user?.uid) {
        await firebaseFirestore
            .collection('users')
            .doc(user?.uid)
            .collection('my_meets')
            .doc(user?.uid)
            .delete();
      }
      if (widget.uid2 == ''){
        await firebaseFirestore
            .collection('public')
            .doc(user?.uid)
            .delete();
      } else {
        await firebaseFirestore
            .collection('users')
            .doc(widget.uid2)
            .collection('my_meets')
            .doc(user?.uid)
            .delete();
      
    }
      }
        navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      
    }

    return Stack(
      children: [
        Image.asset('lib/assets/images/iPhone 14 Pro Max - 14.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 230),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Дата встречи - ${widget.time}',
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Место встречи - ${widget.place}',
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Номер организатора - ${widget.number}',
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Email организатора - ${widget.email}',
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Email принявшего - ${widget.email2}',
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Описание встречи:\n${widget.desc}',
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue,
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: accept,
                        child:  SizedBox(
                            height: 56,
                            child: Center(
                                child: Text(
                              widget.func,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
