import 'package:NoteSup/screen/components/show_note.dart';
import 'package:flutter/material.dart';

void showBottomModal(String documentID, int color, BuildContext context) {
  showModalBottomSheet(
    context: context, 
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: ShowNote(documentID: documentID),
        decoration: BoxDecoration(
          color: Color(color)
        ),
      );
    }
  );
}