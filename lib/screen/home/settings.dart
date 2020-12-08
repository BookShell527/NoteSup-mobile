import 'package:NoteSup/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final User userData = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SettingsList(
          sections: [
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: 'Email',
                  subtitle: userData.email,
                  leading: Icon(Icons.person),
                ),
                SettingsTile(
                  title: 'Sign Out',
                  onPressed: (BuildContext context) async {
                    await _auth.signOut();
                  }
                ),
              ],
            ),
          ],
        ),
      );
  }
}