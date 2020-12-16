import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/screen/components/drawer_menu.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: user.uid).noteCollection.where("uid", isEqualTo: user.uid).where("inTrash", isEqualTo: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Trash"),
            centerTitle: true,
          ),
          drawer: DrawerMenu(),
          body: snapshot.data.docs.length == 0
        ? Center(
          child: Text("No notes moved to trash", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        ) : 
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[500],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Color(document.data()['color'])
                ),
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Text(document.data()['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                    SizedBox(height: 10.0),
                    Center(
                      child: Text(document.data()['body']),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.restore_from_trash_outlined),
                          splashColor: Colors.grey[200],
                          color: Colors.blue,
                          onPressed: () async {
                            await DatabaseService(uid: user.uid).toggleTrash(document.id, snapshot.data.docs[0].data()['inTrash']);
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          splashColor: Colors.grey[200],
                          color: Colors.red,
                          onPressed: () async {
                            await DatabaseService(uid: user.uid).deleteNote(document.id);
                          }
                        )
                      ],
                    )
                  ],
                )
              );
            }).toList(),
          )
        );
      }
    );
  }
}