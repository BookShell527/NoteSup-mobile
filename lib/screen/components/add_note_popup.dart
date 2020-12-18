import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddNotePopup extends StatefulWidget {
  final bool edit;
  final String passedTitle;
  final String passedBody;
  final String documentID;
  final Color passedColor;

  AddNotePopup({this.documentID, this.edit, this.passedBody, this.passedTitle, this.passedColor});
  @override
  _AddNotePopupState createState() => _AddNotePopupState();
}

class _AddNotePopupState extends State<AddNotePopup> {
  final _formKey = GlobalKey<FormState>();

  String _currentTitle = "";
  String _currentBody = "";
  String message = "";
  bool loading = false;
  Color currentColor = Colors.purple[100];

  final TextEditingController txt1 = TextEditingController();
  final TextEditingController txt2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.edit ? widget.passedTitle : "";
    _currentBody = widget.edit ? widget.passedBody : "";
    currentColor = widget.edit ? widget.passedColor : Colors.purple[100];
    txt1.text = widget.passedTitle;
    txt2.text = widget.passedBody;
  }

  final DatabaseService _database = DatabaseService();

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
                    validator: (value) => value.isEmpty ? "Enter a title" : null,
                    controller: txt1,
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
                    controller: txt2,
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
                    child: Text("${widget.edit ? "Update" : "Add"} Note", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        if (widget.edit) {
                          await _database.updateNote(widget.documentID, _currentTitle, _currentBody, currentColor.value);
                        } else {
                          await _database.addNote(user.uid, _currentTitle, _currentBody, currentColor.value);
                        }
                        setState(() {
                          message = "Note ${widget.edit ? "updated" : "added"} successfully";
                          loading = false;
                        });
                        Navigator.pop(context);
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
