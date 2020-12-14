import 'package:NoteSup/screen/home/contact_us.dart';
import 'package:NoteSup/screen/home/settings.dart';
import 'package:flutter/material.dart';
import 'package:NoteSup/screen/home/note.dart' as Note;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentSelectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  final List<Widget> _widgetOptions = <Widget>[
    Note.Note(),
    ContactUs(),
    Settings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentSelectedIndex = index);
          },
          children: _widgetOptions
        ),
      ),
    );
  }
}