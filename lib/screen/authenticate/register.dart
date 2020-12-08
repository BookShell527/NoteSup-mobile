import 'package:NoteSup/services/auth.dart';
import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  // state for form
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(title: Text("Register"), centerTitle: true),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(
                  hintText: "Enter your email"
                ),
                validator: (val) => val.isEmpty || !val.contains("@") ? "Enter a valid email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(hintText: "Enter your password"),
                validator: (val) => val.length < 6 ? "Enter a password with 6+ character" : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                obscureText: true
              ),
              SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                  text: "Already have an accound? Click here",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    widget.toggleView();
                  }
                ),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                color: Colors.purple[400],
                child: Text("Register", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "Couldn't create an account with those credential";
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
            ],
          ),
        ),
      ),
    );
  }
}
