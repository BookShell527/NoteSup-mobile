import 'package:NoteSup/services/auth.dart';
import 'package:NoteSup/shared/constant.dart';
import 'package:NoteSup/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // state for login
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textFormFieldDecoration.copyWith(hintText: "Enter your email"),
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
                  text: "Doesn't have an accound? Click here",
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
                child: Text("Sign In", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "Couldn't sign in with those credential";
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: MaterialButton(
                  color: Colors.white,
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInGoogle();
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = "Couldn't sign in with those credential";
                      });
                    }
                  },
                  child: Text("Sign In With Google", style: TextStyle(color: Colors.grey))
                ),
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