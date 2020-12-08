import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/services/database.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formkey = GlobalKey<FormState>();

  String _currentEmail = '';
  String _currentName = '';
  String _currentMessage = '';
  String successMessage = '';

  final txt1 = TextEditingController();
  final txt2 = TextEditingController();
  final txt3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text("Make sure you have internet connection", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textFormFieldDecoration.copyWith(hintText: "Enter your email"),
                    onChanged: (value) {
                      setState(() => _currentEmail = value);
                    },
                    validator: (value) => value.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
                    controller: txt1
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textFormFieldDecoration.copyWith(hintText: "Enter your name"),
                    onChanged: (value) {
                      setState(() => _currentName = value);
                    },
                    validator: (value) => value.isEmpty ? "Enter your name" : null,
                    controller: txt2
                  ),
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
                  controller: txt3
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.purple,
                  child: Text('Send message',style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await DatabaseService().sendMessage(_currentEmail, _currentName, _currentMessage);
                      setState(() {
                        successMessage = "Message delivered successfully";
                      });
                      txt1.text = "";
                      txt2.text = "";
                      txt3.text = "";
                    }
                  }
                ),
                SizedBox(height: 12.0),
                Text(successMessage, style: TextStyle(color: Colors.green, fontSize: 14.0))
              ],
            ),
          ),
        )
      )
    );
  }
}