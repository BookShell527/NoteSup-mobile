import 'package:NoteSup/models/user.dart';
import 'package:NoteSup/screen/authenticate/authenticate.dart';
import 'package:NoteSup/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
