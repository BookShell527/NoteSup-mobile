import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/screen/components/add_note_popup.dart';
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
  final TextEditingController txt = TextEditingController();
  String message = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    final DatabaseService _database = DatabaseService(uid: user.uid);

    return StreamBuilder(
      stream: _database.noteCollection.where(FieldPath.documentId, isEqualTo: widget.documentID).snapshots() ?? null,
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
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.edit), 
                      color: Colors.orangeAccent,
                      onPressed: () async {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddNotePopup(
                              edit: true,
                              passedTitle: snapshot.data.docs[0].data()['title'],
                              passedBody: snapshot.data.docs[0].data()['body'],
                              documentID: widget.documentID,
                              passedColor: Color(snapshot.data.docs[0].data()['color']),
                            );
                          }
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(snapshot.data.docs[0].data()['important'] ? Icons.star : Icons.star_border, color: Colors.lightBlue),
                      onPressed: () async {
                        await _database.toggleImportant(widget.documentID, snapshot.data.docs[0].data()['important']);
                      },
                    ), 
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.archive, color: Colors.green[700]),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _database.toggleArchived(widget.documentID, snapshot.data.docs[0].data()['archived']);
                      },
                    ), 
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _database.toggleTrash(widget.documentID, snapshot.data.docs[0].data()['inTrash']);
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