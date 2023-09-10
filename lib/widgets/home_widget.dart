import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hack/screens/meet_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("public")
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
            return const Center(
              child: Text('Empty List',
                  style: TextStyle(
                    color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      fontFamily: 'Inter')),
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
          }
          return ListView.builder(
              itemCount: snapshot.requireData.docs.length,
              itemBuilder: (context, index) {
                return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MeetScreen(
                      uid: snapshot.requireData.docs[index]['uid'],
                        desc: snapshot.requireData.docs[index]['desc'],
                        time: snapshot.requireData.docs[index]['time'],
                        place: snapshot.requireData.docs[index]['place'],
                        number: snapshot.requireData.docs[index]['number'],)));
          });
        },
        child: ListTile(
          tileColor: Colors.blue[800],
          textColor: Colors.white,
          title: Text(snapshot.requireData.docs[index]['desc'], maxLines: 1,),
          subtitle: Text(snapshot.requireData.docs[index]['place'], maxLines: 1,),
          trailing: Text(snapshot.requireData.docs[index]['time']),
        ),
      ),
    );
              });
        });
  }
}
