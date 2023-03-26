import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
