import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen(
      {super.key,
      required this.desc,
      required this.number,
      required this.time,
      required this.place,
      required this.uid});
  final String desc;
  final String number;
  final String time;
  final String place;
  final String uid;
  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  @override
  Widget build(BuildContext context) {
    Future accept() async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      if (widget.uid != user?.uid) {
        await firebaseFirestore.collection('public').doc(widget.uid).set({
          'desc': widget.desc,
          'number': widget.number,
          'time': widget.time,
          'place': widget.place,
          'uid': widget.uid,
          'uid2': user?.uid,
        
        });
        await firebaseFirestore.collection('public').doc(user?.uid).set({
          'desc': widget.desc,
          'number': widget.number,
          'time': widget.time,
          'place': widget.place,
          'uid': widget.uid,
          'uid2': user?.uid,
        
        });

        await firebaseFirestore.collection('public').doc(widget.uid).delete();
      }
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
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Дата встречи - ${widget.time}', style: TextStyle(color: Colors.white),),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Место встречи - ${widget.place}', style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Номер организатора - ${widget.number}', style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Описание встречи:\n${widget.desc}', style: TextStyle(color: Colors.white)),
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
                      child: const SizedBox(
                          height: 56,
                          child: Center(
                              child: Text(
                            'ACCEPT',
                            style: TextStyle(
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
      ],
    );
  }
}
