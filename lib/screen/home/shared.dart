import 'package:NoteSup/screen/components/drawer_menu.dart';
import 'package:flutter/material.dart';

class Shared extends StatefulWidget {
  @override
  _SharedState createState() => _SharedState();
}

class _SharedState extends State<Shared> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared with you"),
        centerTitle: true,
      ),
      drawer: DrawerMenu(),
    );
  }
}
