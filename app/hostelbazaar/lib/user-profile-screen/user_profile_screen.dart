import 'package:flutter/material.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/signup-login%20screen/login_screen.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user";

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var userData;
  var userProv;
  bool isLoading = true;

  void initialise() async {
    setState(() {
      isLoading = true;
    });
    userData = await API().getUserInfo();
    // img = userData[0]["profile_img"]
    setState(() {
      isLoading = false;
    });
  }

  void logout() async {
    setState(() {
      isLoading = true;
    });
    userProv.logout();
    Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Column(
              children: [
                Header(
                  showProfile: false,
                  showWishlist: false,
                ),
                SizedBox(height: 100),
                Container(
                  child: Image.asset("assets/images/${userData[0]['profile_image']}.png"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      logout();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
    );
  }
}
