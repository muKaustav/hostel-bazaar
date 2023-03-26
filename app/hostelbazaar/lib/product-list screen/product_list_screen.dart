import 'package:flutter/material.dart';
import 'package:hostelbazaar/empty.dart';
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/product-list%20screen/product_details_screen.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/providers/wishlist.dart';
import 'package:hostelbazaar/search-screen/search_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/otp_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = "/products";

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  var userProv;
  bool isLoading = true;
  final searchController = new TextEditingController();
  List<dynamic> searchResults = [];
  var wishlistProv;

  void initialiseData() async {
    setState(() {
      isLoading = true;
    });
    var response = await API().getProductsByCategory(userProv.selectedCategory);
    userProv.selectedCategoryProductList = response;

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

  void search() async {
    setState(() {
      isLoading = true;
    });
    var response = await API().searchProduct(searchController.text);
    userProv.selectedCategoryProductList = response;
    Navigator.of(context).pushReplacementNamed(SearchScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : Column(
              children: [
                Header(),
                SizedBox(height: 20),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            height: 50,
                            child: Row(
                              children: [
                                Image.asset("assets/images/drawer.png"),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration.collapsed(hintText: "search"),
                                    onChanged: (_) async {
                                      if (searchController.text.isEmpty) {
                                        setState(() {
                                          searchResults = [];
                                        });
                                        return;
                                      }
                                      searchResults = await API().searchProduct(searchController.text);
                                      setState(() {});
                                    },
                                  ),
                                )),
                                GestureDetector(
                                    onTap: () {
                                      if (searchController.text.isNotEmpty) search();
                                    },
                                    child: Image.asset("assets/images/search.png")),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Sort by: Popularity",
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     Container(
                          //       decoration: BoxDecoration(
                          //         color: secondaryColor,
                          //         borderRadius: BorderRadius.circular(4),
                          //       ),
                          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          //       child: Text(
                          //         "Filters",
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Stack(
                        children: [
                          if (userProv.selectedCategoryProductList.isNotEmpty)
                            ListView.builder(
                              // cacheExtent: 9999,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // userProv.selectedProductIndex = index;
                                    userProv.selectedProduct = userProv.selectedCategoryProductList[index];
                                    Navigator.of(context).pushNamed(ProductDetailsScreen.routeName);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
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
                                            height: 80,
                                            width: 80,
                                            color: Colors.grey,
                                            child: Image.network(
                                              userProv.selectedCategoryProductList[index]["image"].toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userProv.selectedCategoryProductList[index]["name"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "₹ " + userProv.selectedCategoryProductList[index]["price"].toString(),
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
                                        ),
                                        Spacer(),
                                        if (wishlistProv.wishlist.isEmpty) Container(height: 20, child: Image.asset("assets/images/unlike.png")),
                                        if (wishlistProv.wishlist.isNotEmpty)
                                          GestureDetector(
                                            onTap: () async {
                                              if (!wishlistProv.containsProduct(userProv.selectedCategoryProductList[index]["_id"])) {
                                                var response = await API().addToWishlist(userProv.selectedCategoryProductList[index]["_id"]);
                                                wishlistProv.addProduct(userProv.selectedCategoryProductList[index]);
                                              } else {
                                                var response = await API().removeFromWishlist(userProv.selectedCategoryProductList[index]["_id"]);
                                                wishlistProv.removeProduct(userProv.selectedCategoryProductList[index]["_id"]);
                                              }
                                            },
                                            child: Consumer<Wishlist>(
                                              builder: (context, value, child) => Container(child: !wishlistProv.containsProduct(userProv.selectedCategoryProductList[index]["_id"]) ? Container(height: 20, child: Image.asset("assets/images/unlike.png")) : Container(height: 20, child: Image.asset("assets/images/like.png"))),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              itemCount: userProv.selectedCategoryProductList.length,
                              padding: EdgeInsets.all(0),
                            ),
                          if (userProv.selectedCategoryProductList.isEmpty) Empty(),
                          if (searchResults.length != 0)
                            Positioned(
                              top: -20,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                ),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: bgcolor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      ...searchResults.map((e) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (searchController.text.isNotEmpty) search();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                width: double.infinity,
                                                child: Text(
                                                  e["name"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0.5,
                                            ),
                                          ],
                                        );
                                      }),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                )),
                Footer(
                  current: "",
                  ctx: context,
                ),
              ],
            ),
    );
  }
}
