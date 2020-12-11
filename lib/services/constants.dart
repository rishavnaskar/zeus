import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(
    top: BorderSide(color: Colors.white, width: 2.0),
  ),
);

const kSignInTextFieldDecoration = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white));

kBackButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.arrow_back),
    color: Color(0xff520935),
    onPressed: () => Navigator.pop(context),
  );
}