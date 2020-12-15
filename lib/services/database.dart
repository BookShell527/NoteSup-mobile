import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference noteCollection = FirebaseFirestore.instance.collection("note");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("message");

  Future sendMessage(String email, String name, String message) async {
    return await messageCollection.doc(uid).set({'email': email, 'name': name, 'message': message});
  }

  Future addNote(String uid, String title, String body, int color) async {
    return await noteCollection.doc().set({
      'uid': uid,
      'title': title,
      'body': body,
      'important': false,
      'color': color
    });
  }

  Future deleteNote(String documentID) async  {
    await DatabaseService(uid: uid).noteCollection.doc(documentID).delete();
  }

  Future toggleImportant(String documentID, bool important) async {
    await DatabaseService(uid: uid).noteCollection.doc(documentID).update({"important": !important});
  }
}
