import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference noteCollection = FirebaseFirestore.instance.collection("note");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("message");

  Future sendMessage(String email, String name, String message) async {
    return await messageCollection.doc(uid).set({'email': email, 'name': name, 'message': message});
  }
}
