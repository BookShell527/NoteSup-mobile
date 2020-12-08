import 'package:NoteSup/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  int _currentSelectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text("Sign Out", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            }
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        selectedItemColor: Colors.purple[800],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentSelectedIndex),
      ),
    );
  }
}
