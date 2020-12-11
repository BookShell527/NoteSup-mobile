import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/services/database.dart';
import 'package:flutter/material.dart';
import 'package:NoteSup/screen/components/add_note_popup.dart';
import 'package:provider/provider.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return StreamProvider<List>.value(
      value: DatabaseService(uid: user.uid).note,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Note"),
          centerTitle: true,
        ),
        body: Container(
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddNotePopup();
              }
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      )
    );
  }
}