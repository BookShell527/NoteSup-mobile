import 'package:NoteSup/screen/home/archived.dart';
import 'package:NoteSup/screen/home/contact_us.dart';
import 'package:NoteSup/screen/home/home.dart';
import 'package:NoteSup/screen/home/trash.dart';
import 'package:NoteSup/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
              ),
              child: FirebaseAuth.instance.currentUser.photoURL.isNotEmpty ? Image.network(FirebaseAuth.instance.currentUser.photoURL.toString(), fit: BoxFit.contain) : Image.asset("assets/person.png"),
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(FirebaseAuth.instance.currentUser.email),
          ),
          Divider(height: 1.0, color: Colors.grey),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          ListTile(
            title: Text('Archived'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Archived()));
            },
          ),
          ListTile(
            title: Text('Trash'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Trash()));
            },
          ),
          ListTile(
            title: Text('Contact Us'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
            },
          ),
          Divider(height: 1.0, color: Colors.grey),
          ListTile(
            title: Text('Sign Out'),
            onTap: () async {
              await AuthService().signOut();
            }
          )
        ],
      ),
    );
  }
}