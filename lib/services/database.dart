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
      'inTrash': false,
      'archived': false,
    });
  }

  Future deleteNote(String documentID) async  {
    await noteCollection.doc(documentID).delete();
  }

  Future toggleImportant(String documentID, bool important) async {
    await noteCollection.doc(documentID).update({"important": !important});
  }

  Future toggleTrash(String documentID, bool inTrash) async {
    await noteCollection.doc(documentID).update({"inTrash": !inTrash});
  }

  Future toggleArchived(String documentID, bool archived) async {
    await noteCollection.doc(documentID).update({"archived": !archived});
  }

  Future deleteAll(String uid) async {
    await noteCollection.get().then((snapshot) async {
      List<DocumentSnapshot> allDocs = snapshot.docs;
      List<DocumentSnapshot> filteredDocs = allDocs.where((document) => document.data()['uid'] == uid).where((document) => document.data()['inTrash'] == true).toList();

      for (DocumentSnapshot ds in filteredDocs) {
        await ds.reference.delete();
      }
    });
  }

  Future updateNote(String documentID, String title, String body, int color) async {
    await noteCollection.doc(documentID).update({
      'title': title,
      'body': body,
      'color': color
    });
  }
}
