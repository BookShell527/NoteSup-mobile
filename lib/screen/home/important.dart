import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/screen/components/drawer_menu.dart';
import 'package:NoteSup/screen/components/show_note.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Important extends StatefulWidget {
  @override
  ImportantState createState() => ImportantState();
}

class ImportantState extends State<Important> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    void _showBottomModal(String documentID, int color) {
      showModalBottomSheet(
        context: context, 
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: ShowNote(documentID: documentID),
            decoration: BoxDecoration(
              color: Color(color)
            ),
          );
        }
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: user.uid).noteCollection.where("uid", isEqualTo: user.uid).where("important", isEqualTo: true).where("inTrash", isEqualTo: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Important"),
            centerTitle: true,
          ),
          drawer: DrawerMenu(),
          body: snapshot.data.docs.length == 0
        ? Center(
          child: Text("No notes marked as important", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        ) : GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () => _showBottomModal(document.id, document.data()['color']),
                child: Container(
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
                            icon: Icon(document.data()['important'] ? Icons.star : Icons.star_border), 
                            color: Colors.blue,
                            splashColor: Colors.grey[200],
                            onPressed: () async {
                              await DatabaseService(uid: user.uid).toggleImportant(document.id, snapshot.data.docs[0].data()['important']);
                            }
                          ),
                        ],
                      )
                    ],
                  )
                ),
              );
            }).toList(),
          ),
        );
      }
    );
  }
}