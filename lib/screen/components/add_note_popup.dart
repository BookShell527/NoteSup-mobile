import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddNotePopup extends StatefulWidget {
  @override
  _AddNotePopupState createState() => _AddNotePopupState();
}

class _AddNotePopupState extends State<AddNotePopup> {
  final _formKey = GlobalKey<FormState>();

  String _currentTitle = "";
  String _currentBody = "";
  String message = "";
  bool loading = false;

  final DatabaseService _database = DatabaseService();

  Color currentColor = Colors.purple[200];
  void changeColor(Color color) => setState(() => currentColor = color);
  List<Color> colorChoice = <Color>[Colors.purple[100], Colors.red[100], Colors.green[100], Colors.blue[100], Colors.yellow[100]];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    return AlertDialog(
      content: loading ? Loading() : Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.purple,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: textFormFieldDecoration.copyWith(hintText: "Title"),
                    onChanged: (value) => _currentTitle = value,
                    validator: (value) => value.isEmpty ? "Enter a title" : null
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: textFormFieldDecoration.copyWith(hintText: "Take a note..."),
                    onChanged: (value) => _currentBody = value,
                    validator: (value) => value.isEmpty ? "Enter a note" : null,
                    minLines: 2,
                    maxLines: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: colorChoice.map((Color e) {
                      return Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: e == currentColor ? Colors.black : Colors.grey,
                                width: e == currentColor ? 2 : 1.5
                              ),
                              color: e
                            ),
                          ),
                          onTap: () {
                            changeColor(e);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.purple,
                    child: Text("Add Note", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        await _database.addNote(user.uid, _currentTitle, _currentBody, currentColor.value);
                        setState(() {
                          message = "Note added successfully";
                          loading = false;
                        });
                      }
                    },
                  ),
                ),
                Text(message, style: TextStyle(color: Colors.green))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
