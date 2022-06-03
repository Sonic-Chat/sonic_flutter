import 'package:flutter/material.dart';

void displaySnackBar(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
