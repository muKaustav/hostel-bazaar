import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/signup-login%20screen/details_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/otp_screen.dart';
import 'package:hostelbazaar/url.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "/signup";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userProv;
  List<dynamic> data = [];
  bool isLoading = true;

  void initialise() async {
    data = await API().getColleges();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Center(
                child: Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      Container(
                        height: 50,
                        child: Image.asset(
                          "assets/images/logo.png",
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        children: [
                          Text(
                            "College Name: ",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Center(
                                        child: Container(
                                            width: 350,
                                            height: 500,
                                            decoration: BoxDecoration(
                                              color: bgcolor,
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: primaryColor, width: 2),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemBuilder: ((ctx, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            userProv.college = data[index];
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                            color: Colors.grey,
                                                          ))),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: DefaultTextStyle(
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontFamily: "Poppins",
                                                                fontSize: 16,
                                                              ),
                                                              child: Text(
                                                                data[index]["name"],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    itemCount: data.length,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: userProv.college.isEmpty
                                      ? Text(
                                          "Select College",
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                          ),
                                        )
                                      : Text(
                                          userProv.college['name'],
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                          ),
                                        ))),
                        ),
                      ),
                      SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          height: 40,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () {
                                if (userProv.college.isEmpty) {
                                  final snackBar = SnackBar(
                                    content: Text("Select your college!"),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }
                                Navigator.of(context).pushNamed(DetailsScreen.routeName);
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
                      SizedBox(
                        height: 100,
                      ),
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
      ),
    );
  }
}
