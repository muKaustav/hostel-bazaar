import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';

class BusyScreen extends StatelessWidget {
  static const routeName = "/busy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Please update the app!",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
