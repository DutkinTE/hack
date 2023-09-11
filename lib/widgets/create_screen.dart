// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/screens/meet_screen.dart';
import 'package:intl/intl.dart';

class CreateWidget extends StatefulWidget {
  const CreateWidget({super.key});

  @override
  State<CreateWidget> createState() => _CreateWidgetState();
}

class _CreateWidgetState extends State<CreateWidget> {
  TextEditingController placeTextInputController = TextEditingController();
  TextEditingController numberTextInputController = TextEditingController();
  TextEditingController descTextInputController = TextEditingController();
  TextEditingController timeTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      placeTextInputController.dispose();
      numberTextInputController.dispose();
      descTextInputController.dispose();
      timeTextInputController.dispose();

      super.dispose();
    }

    // ignore: non_constant_identifier_names
    Future<void> create() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;
      final navigator = Navigator.of(context);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      await firebaseFirestore.collection('public').doc(user?.uid).set({
        'place': placeTextInputController.text,
        'number': numberTextInputController.text,
        'desc': descTextInputController.text,
        'time': timeTextInputController.text,
        'uid': user?.uid,
        'email': user?.email,
        'uid2': '',
        'email2': ''
      });

      await firebaseFirestore
          .collection('users')
          .doc(user?.uid)
          .collection('my_meets')
          .doc(user?.uid)
          .set({
        'place': placeTextInputController.text,
        'number': numberTextInputController.text,
        'desc': descTextInputController.text,
        'time': timeTextInputController.text,
        'uid': user?.uid,
        'email': user?.email,
        'uid2': '',
        'email2': ''
      });

      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }

    Future delete({required uid2, required uid1}) async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      if (uid1 == user?.uid) {
        await firebaseFirestore
            .collection('users')
            .doc(user?.uid)
            .collection('my_meets')
            .doc(user?.uid)
            .delete();
      }
      if (uid2 == ''){
        await firebaseFirestore
            .collection('public')
            .doc(user?.uid)
            .delete();
      } else {
        await firebaseFirestore
            .collection('users')
            .doc(uid2)
            .collection('my_meets')
            .doc(user?.uid)
            .delete();
      }
    }

    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .collection('my_meets')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Loading...',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      fontFamily: 'Inter')),
            );
          }
          if (snapshot.requireData.docs.isEmpty) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 230.0),
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 30, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Place',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            autocorrect: false,
                            controller: placeTextInputController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value == '' ? 'Enter place' : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Number',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            autocorrect: false,
                            controller: numberTextInputController,
                            keyboardType: TextInputType.phone,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value == '' ? 'Enter phone' : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Date',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            autocorrect: false,
                            controller: timeTextInputController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value == '' ? 'Enter date' : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
              
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  timeTextInputController.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Description',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: descTextInputController,
                            validator: (value) =>
                                value == '' ? 'Enter desc' : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            minLines: 4,
                            maxLines: 4,
                          ),
                          const SizedBox(
                            height: 32,
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
                            onPressed: create,
                            child: const SizedBox(
                                height: 56,
                                child: Center(
                                    child: Text(
                                  'CREATE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong.',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      fontFamily: 'Inter')),
            );
          } else {
            if (snapshot.requireData.docs.length == 1) {
              return Padding(
            padding: const EdgeInsets.only(top: 280, left: 30, right: 30),
                child: ListView(
                  children: [
                    Text(
                        'Дата встречи - ${snapshot.requireData.docs[0]['time']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        'Место встречи - ${snapshot.requireData.docs[0]['place']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        'Номер организатора - ${snapshot.requireData.docs[0]['number']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        'Email организатора - ${snapshot.requireData.docs[0]['email']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        'Email принявшего - ${snapshot.requireData.docs[0]['email2']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        'Описание встречи:\n${snapshot.requireData.docs[0]['desc']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
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
                      onPressed: () {
                        delete(
                            uid2: snapshot.requireData.docs[0]['uid2'],
                            uid1: snapshot.requireData.docs[0]['uid']);
                      },
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
            else {
              return Padding(
            padding: const EdgeInsets.only(top: 260),
                child: ListView.builder(
                itemCount: snapshot.requireData.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20, left: 30),
                    child: Card(
                      
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MeetScreen(
                                      email2: snapshot.requireData.docs[index]
                                              ['email2'],
                                      uid2: snapshot.requireData.docs[index]
                                              ['uid2'],
                                      email:  snapshot.requireData.docs[index]
                                              ['email'],
                                      func: 'DELETE',
                                          uid: snapshot.requireData.docs[index]
                                              ['uid'],
                                          desc: snapshot.requireData.docs[index]
                                              ['desc'],
                                          time: snapshot.requireData.docs[index]
                                              ['time'],
                                          place: snapshot.requireData.docs[index]
                                              ['place'],
                                          number: snapshot.requireData.docs[index]
                                              ['number'],
                                        )));
                          });
                        },
                        child: ListTile(
                          tileColor: Colors.blue,
                          textColor: Colors.white,
                          title: Text(
                            snapshot.requireData.docs[index]['desc'],
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            snapshot.requireData.docs[index]['place'],
                            maxLines: 1,
                          ),
                          trailing:
                              Text(snapshot.requireData.docs[index]['time']),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
          }
        });
  }
}
