import 'package:flutter/material.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/user-profile-screen/user_profile_screen.dart';
import 'package:hostelbazaar/wishlist_screen/wishlist_screen.dart';

class Header extends StatelessWidget {
  bool showWishlist;
  bool showProfile;

  Header({this.showWishlist = true, this.showProfile = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Container(
          height: 50,
          // color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).pushNamedAndRemoveUntil(Homescreen.routeName, (route) => false);
                      }),
                      child: Container(
                        height: 30,
                        child: Image.asset(
                          "assets/images/logo.png",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (showWishlist)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(WishlistScreen.routeName);
                        },
                        child: Container(
                          // color: Colors.blue,
                          height: 23,
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/images/like.png",
                          ),
                        ),
                      ),
                    SizedBox(width: 20),
                    if (showProfile)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(UserProfileScreen.routeName);
                        },
                        child: Container(
                          // color: Colors.blue,
                          height: 23,
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset("assets/images/user.png"),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: primaryColor,
        ),
      ],
    );
  }
}
