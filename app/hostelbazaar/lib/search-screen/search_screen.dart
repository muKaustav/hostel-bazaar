import 'package:flutter/material.dart';
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/product-list%20screen/product_details_screen.dart';
import 'package:hostelbazaar/product-list%20screen/product_list_screen.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var userProv;
  bool isLoading = false;
  final searchController = new TextEditingController();

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
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
      drawer: MainDrawer(),
      backgroundColor: bgcolor,
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
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              userProv.selectedProduct = userProv.selectedCategoryProductList[index];
                              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                        userProv.selectedCategoryProductList[index]["image"],
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
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                        itemCount: userProv.selectedCategoryProductList.length,
                        padding: EdgeInsets.all(0),
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
