import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/signup-login%20screen/otp_screen.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = "/user-details";

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final upiController = new TextEditingController();
  String error = "";

  bool verify() {
    if (nameController.text.isEmpty) {
      error = "Please enter your name!";
      return false;
    }
    if (emailController.text.isEmpty) {
      error = "Please enter your email";
      return false;
    }
    if (passwordController.text.isEmpty) {
      error = "Please enter a password!";
      return false;
    }
    if (upiController.text.isEmpty || !upiController.text.contains('@')) {
      error = "Please enter a valid UPI id!";
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              Container(
                height: 50,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              SizedBox(height: 60),
              inputText("Full Name", nameController, false),
              SizedBox(height: 20),
              inputText("Email", emailController, false),
              SizedBox(height: 20),
              inputText("Password", passwordController, true),
              SizedBox(height: 20),
              inputText("UPI", upiController, false),
              SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!verify()) {
                          final snackBar = SnackBar(
                            content: Text(error),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        var userProv = Provider.of<User>(context, listen: false);
                        userProv.name = nameController.text;
                        userProv.email = emailController.text;
                        userProv.password = passwordController.text;
                        userProv.upi = upiController.text;
                        Navigator.of(context).pushNamed(OTPScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Have an account? ",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Log in.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container inputText(String hintText, TextEditingController controller, bool password) {
    return Container(
      height: 50,
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          obscureText: password ? true : false,
          controller: controller,
          decoration: InputDecoration.collapsed(
            hintText: "$hintText",
          ),
        ),
      ),
    );
  }
}
