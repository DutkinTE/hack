import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/widgets/create_screen.dart';
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
      const CreateWidget(),
      const ProfileWidget(),
    ];
    return Stack(
      children: [
        Image.asset('lib/assets/images/iPhone 14 Pro Max - 14.png', width: double.infinity,),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromRGBO(60, 60, 67, 0.36)))),
            child: BottomNavigationBar(
              unselectedLabelStyle: const TextStyle(color: Colors.white),
              selectedLabelStyle: const TextStyle(color: Colors.white),
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              elevation: 0,
              backgroundColor: Colors.blue,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home, color: Colors.white,),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.pen, color: Colors.white),
                  label: 'My meet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_crop_circle_fill, color: Colors.white),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
          body: widgetOptions[_selectedIndex],
        ),
      ],
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