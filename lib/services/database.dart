import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference noteCollection = FirebaseFirestore.instance.collection("note");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("message");

  Future sendMessage(String message) async {
    return await messageCollection.doc(uid).set({'email': FirebaseAuth.instance.currentUser.email, 'message': message});
  }

  Future addNote(String uid, String title, String body, int color) async {
    return await noteCollection.doc().set({
      'uid': uid,
      'title': title,
      'body': body,
      'important': false,
      'color': color,
      'inTrash': false
    });
  }

  Future deleteNote(String documentID) async  {
    await DatabaseService(uid: uid).noteCollection.doc(documentID).delete();
  }

  Future toggleImportant(String documentID, bool important) async {
    await DatabaseService(uid: uid).noteCollection.doc(documentID).update({"important": !important});
  }

  Future toggleTrash(String documentID, bool inTrash) async {
    await DatabaseService(uid: uid).noteCollection.doc(documentID).update({"inTrash": !inTrash});
  }
}
