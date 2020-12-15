import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowNote extends StatefulWidget {
  final String documentID;
  ShowNote({ this.documentID });

  @override
  _ShowNoteState createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).noteCollection.where(FieldPath.documentId, isEqualTo: widget.documentID).snapshots() ?? null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(snapshot.data.docs[0].data()['title'] ?? "", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Center(
                child: Text(snapshot.data.docs[0].data()['body'] ?? "", style: TextStyle(fontSize: 20.0))
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  Expanded(child: Icon(Icons.edit, color: Colors.orangeAccent)),
                  Expanded(
                    child: IconButton(
                      icon: Icon(snapshot.data.docs[0].data()['important'] ? Icons.star : Icons.star_border, color: Colors.lightBlue),
                      onPressed: () async {
                        await DatabaseService(uid: user.uid).toggleImportant(widget.documentID, snapshot.data.docs[0].data()['important']);
                      },
                    ), 
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        Navigator.pop(context);
                        await DatabaseService(uid: user.uid).deleteNote(snapshot.data.docs[0].id);
                      },
                    ), 
                  ),
                ],
              )
            ]
          );
        } else if (snapshot.hasError) {
          return Text("Error Occurs", style: TextStyle(color: Colors.red));
        } else if (!snapshot.hasData) {
          return Loading();
        } else {
          return Loading();
        }
      }
    );
  }
}