import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/services/database.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String _currentMessage = '';
  String successMessage = '';

  final txt1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          title: Text("Contact Us"),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
              key: _formkey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("Make sure you have internet connection",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        validator: (value) => value.isEmpty ? "Enter your message" : null,
                        maxLines: null,
                        minLines: 4,
                        decoration: textFormFieldDecoration.copyWith(hintText: "Your message"),
                        onChanged: (value) {
                          setState(() => _currentMessage = value);
                        },
                        controller: txt1),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.purple,
                        child: Text('Send message',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await DatabaseService().sendMessage(_currentMessage);
                            setState(() {
                              successMessage = "Message delivered successfully";
                              loading = false;
                            });
                            txt1.text = "";
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(successMessage,
                        style: TextStyle(color: Colors.green, fontSize: 14.0))
                  ],
                ),
              ),
            )));
  }
}
