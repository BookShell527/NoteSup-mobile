import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

const textFormFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 2.0)),
);

ago(Timestamp t) {
  return timeago.format(t.toDate(), locale: "en_short");
}