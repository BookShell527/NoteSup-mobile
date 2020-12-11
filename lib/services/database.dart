import 'package:NoteSup/models/note.dart';
import 'package:NoteSup/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference noteCollection = FirebaseFirestore.instance.collection("note");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("message");

  Future sendMessage(String email, String name, String message) async {
    return await messageCollection.doc(uid).set({'email': email, 'name': name, 'message': message});
  }

  Future addNote(String uid, String title, String body) async {
    return await noteCollection.doc().set({
      'uid': uid,
      'title': title,
      'body': body
    });
  }

  List<Note> _noteFromSnapshot(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      if (uid != doc.data()['uid']) {
        return null;
      }
      else {
        return Note(
          uid: uid,
          title: doc.data()['title'],
          body: doc.data()['body']
        );
      }
    }).toList();
  }

  Stream<List<Note>> get note {
    return noteCollection.snapshots().map(_noteFromSnapshot);
  }
}
