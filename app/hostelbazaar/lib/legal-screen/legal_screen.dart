import 'package:flutter/material.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/legal.dart';
import 'package:hostelbazaar/palette.dart';

class LegalScreen extends StatelessWidget {
  static const routeName = "/legal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Header(
            showProfile: false,
            showWishlist: false,
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: secondaryColor, width: 5),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(
                  LEGAL,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
