import 'package:flutter/material.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/signup-login%20screen/login_screen.dart';
import 'package:provider/provider.dart';

class HostelScreen extends StatefulWidget {
  static const routeName = "/hostel";

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  final roomNumberController = new TextEditingController();
  var userProv;
  List<dynamic> data = [];
  bool isLoading = true;
  String error = "";

  void initialise() async {
    data = await API().getHostels(userProv.college["_id"]);
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

  bool verify() {
    if (userProv.hostel.isEmpty) {
      error = "Please select your hostel!";
      return false;
    }
    if (roomNumberController.text.length == 0) {
      error = "Please enter room number!";
      return false;
    }
    if (userProv.selectedImg == -1) {
      error = "Please select a profile image!";
      return false;
    }

    return true;
  }

  void signUp() async {
    Map<String, String> body = {
      "name": userProv.name,
      "email": userProv.email,
      "password": userProv.password,
      "profile_image": userProv.selectedImg.toString(),
      "hostel": userProv.hostel["_id"].toString(),
      "college": userProv.college["_id"].toString(),
      "room_number": roomNumberController.text,
      "contact": userProv.contact,
      "UPI": userProv.upi,
    };
    print(body);
    var response = await API().signUp(body);
    if (response["success"] == true) {
      final snackBar = SnackBar(
        content: Text("Verification email sent! Please verify your email and then log in."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    } else {
      final snackBar = SnackBar(
        content: Text("Error! Please try again!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // print(userProv.name + userProv.email + userProv.password + userProv.selectedImg.toString() + userProv.hostel["_id"].toString() + userProv.college["_id"].toString() + roomNumberController.text);
    // var response = await API().signUp(userProv.name, userProv.email, userProv.password, userProv.selectedImg.toString(), userProv.hostel["_id"].toString(), userProv.college["_id"].toString(), roomNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
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
              SizedBox(height: 100),
              GestureDetector(
                onTap: () {
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
                                              userProv.hostel = data[index];
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
                child: Container(
                  height: 50,
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: userProv.hostel.isEmpty
                        ? Text(
                            "Hostel Name",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            userProv.hostel["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              inputText("Room Number", roomNumberController, false),
              if (userProv.selectedImg != -1)
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "assets/images/${userProv.selectedImg}.png",
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (context, StateSetter setStat) {
                                return Center(
                                  child: Container(
                                      width: 350,
                                      height: 500,
                                      decoration: BoxDecoration(
                                        color: bgcolor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: GridView(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 40,
                                                  crossAxisSpacing: 10,
                                                ),
                                                children: [
                                                  avatar("1", 1, setStat),
                                                  avatar("2", 2, setStat),
                                                  avatar("3", 3, setStat),
                                                  avatar("4", 4, setStat),
                                                  avatar("5", 5, setStat),
                                                  avatar("6", 6, setStat),
                                                  avatar("7", 7, setStat),
                                                  avatar("8", 8, setStat),
                                                  avatar("9", 9, setStat),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            height: 40,
                                            width: 350,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: secondaryColor,
                                                ),
                                                child: Text(
                                                  "Done",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                  ),
                                                )),
                                          )
                                        ],
                                      )),
                                );
                              });
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                      child: Text(
                        "Select Profile Picture",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                        signUp();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector avatar(String img, int n, StateSetter setStat) {
    return GestureDetector(
        onTap: () {
          setStat(() {
            userProv.selectedImg = n;
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: userProv.selectedImg == n ? primaryColor : null,
              borderRadius: userProv.selectedImg == n ? BorderRadius.circular(15) : null,
            ),
            child: Image.asset("assets/images/$img.png")));
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
