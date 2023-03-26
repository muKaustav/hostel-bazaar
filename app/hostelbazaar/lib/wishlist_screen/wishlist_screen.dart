import 'package:flutter/material.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/product-list%20screen/product_details_screen.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/providers/wishlist.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  static const routeName = "/wishlist";

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool isLoading = true;
  var userProv;
  var wishlistProv;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> initialiseData() async {
    var response = await API().getWishlist();
    if (response.isEmpty)
      wishlistProv.wishlist = [];
    else
      wishlistProv.wishlist = response[0]["items"];

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    wishlistProv = Provider.of<Wishlist>(context, listen: false);
    initialiseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: bgcolor,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : Column(
                children: [
                  Header(showWishlist: false),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Wishlist",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Consumer<Wishlist>(builder: (context, value, child) {
                    if (wishlistProv.wishlist.isEmpty)
                      return Expanded(
                        child: Center(
                          child: Container(
                            height: 200,
                            margin: EdgeInsets.only(bottom: 70),
                            child: Image.asset(
                              "assets/images/empty.png",
                            ),
                          ),
                        ),
                      );
                    return Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              userProv.selectedProduct = wishlistProv.wishlist[index]["product"];
                              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: bgLite,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey,
                                      child: Image.network(
                                        wishlistProv.wishlist[index]["product"]["image"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        wishlistProv.wishlist[index]["product"]["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "₹ " + wishlistProv.wishlist[index]["product"]["price"].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "In stock.",
                                        style: TextStyle(
                                          color: mainColor,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: wishlistProv.wishlist.length,
                      ),
                    );
                  })
                ],
              ));
  }
}
