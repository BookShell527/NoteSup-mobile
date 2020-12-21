import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/screen/components/add_note_popup.dart';
import 'package:NoteSup/screen/components/drawer_menu.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:NoteSup/shared/show_bottom_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:NoteSup/shared/constant.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Note"),
        centerTitle: true,
      ),
      drawer: DrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddNotePopup(edit: false);
            }
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _database.noteCollection.orderBy("important", descending: true).where("uid", isEqualTo: user.uid).where("archived", isEqualTo: false).where("inTrash", isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return snapshot.data.docs.length == 0 ? Center(child: Text("No notes added", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))) : GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () => showBottomModal(document.id, document.data()['color'], context),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 12.0, 0),
                            child: Text(ago(document.data()['createdDate'])),
                          ),
                          IconButton(
                            icon: Icon(document.data()['important'] ? Icons.star : Icons.star_border), 
                            color: Colors.blue,
                            splashColor: Colors.grey[200],
                            onPressed: () async {
                              await DatabaseService(uid: user.uid).toggleImportant(document.id, document.data()['important']);
                            }
                          ),
                        ],
                      )
                    ],
                  )
                ),
              );
            }).toList()
          );
              }
      ),
    );
  }
}