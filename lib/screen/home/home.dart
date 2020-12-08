import 'package:NoteSup/screen/home/contact_us.dart';
import 'package:NoteSup/screen/home/note.dart';
import 'package:NoteSup/screen/home/settings.dart';
import 'package:NoteSup/services/auth.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentSelectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[
    Settings(),
    Note(),
    ContactUs()
  ];

  void _onItemTapped(int index) {
  setState(() {
    _currentSelectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Contact Us',
          ),
        ],
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentSelectedIndex),
      ),
    );
  }
}