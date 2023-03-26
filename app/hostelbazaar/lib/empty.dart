import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(height: 50),
        Container(
          height: 200,
          margin: EdgeInsets.only(bottom: 70),
          child: Image.asset(
            "assets/images/empty.png",
          ),
        ),
        Text(
          "Nothing to show :(",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    ));
  }
}
