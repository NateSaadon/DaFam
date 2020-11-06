import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Color.fromARGB(150, 86, 195, 187),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color.fromARGB(150, 86, 195, 187), width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  prefixIcon: Padding(
    padding: const EdgeInsets.only(right: 2.0, left: 10),
    child: Icon(
      Icons.email,
      size: 25.0,
      color: Color.fromARGB(150, 86, 195, 187),
    ),
  ),
  hintText: 'Enter your email',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(150, 86, 195, 187), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(150, 86, 195, 187), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
