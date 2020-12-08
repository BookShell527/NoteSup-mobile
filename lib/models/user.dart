class TheUser {
  final String uid;
  final String email;

  TheUser({this.uid, this.email});
}

class Note {
  final String title;
  final String body;

  Note({this.title, this.body});
}

class TheUserData {
  final String uid;
  final String email;
  final List<Note> note;

  TheUserData({
    this.note,
    this.email,
    this.uid,
  });
}
