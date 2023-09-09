import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/widgets/home_widget.dart';
import 'package:hack/widgets/profile_widget.dart';



class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  
  User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const HomeWidget(),
      const TestWidget(),
      const ProfileWidget()
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: Color.fromRGBO(60, 60, 67, 0.36)))),
        child: BottomNavigationBar(
          unselectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
          selectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color.fromRGBO(122, 122, 122, 1),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(249, 249, 249, 0.94),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.globe),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle_fill),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      body: widgetOptions[_selectedIndex],
    );
  }
}


class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Screen'));
  }
}