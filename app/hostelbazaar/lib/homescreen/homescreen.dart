import 'package:flutter/material.dart';
import 'package:hostelbazaar/busy.dart';
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/product-list%20screen/product_list_screen.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/tokens.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/providers/wishlist.dart';
import 'package:hostelbazaar/search-screen/search_screen.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final searchController = new TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = true;
  var userProv;
  var wishlistProv;

  Future<void> initialiseData() async {
    // setState(() {
    //   isLoading = true;
    // });
    // API.context = context;
    // var version = await API().getVersion();
    // if (version["version"] != "1.0.0+5") {
    //   Navigator.of(context).pushNamed(BusyScreen.routeName);
    //   return;
    // }

    // dynamic response = await API().getLastNOrders();
    // userProv.lastNOrders = response;

    var resp = await API().getWishlist();

    // if (resp.isEmpty)
    //   wishlistProv.wishlist = [];
    // else
    //   wishlistProv.wishlist = resp[0]["items"];

    // setState(() {
    //   isLoading = false;
    // });
  }

  void search() async {
    setState(() {
      isLoading = true;
    });
    print("in");
    var response = await API().searchUniqueProduct(searchController.text);
    userProv.selectedCategoryProductList = response;
    Navigator.of(context).pushNamed(SearchScreen.routeName).then((value) {
      setState(() {
        isLoading = false;
      });
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
    print(userProv.lastNOrders);
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Column(
              children: [
                Header(),
                SizedBox(height: 20),
                if (userProv.lastNOrders.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      // cacheExtent: 9999,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: userProv.lastNOrders.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          width: 150,
                          margin: index == 0 ? EdgeInsets.only(left: w * 0.06, right: 10) : EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              userProv.lastNOrders[index]["items"][0]["product"]["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
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
                        Expanded(
                          // height: 200,
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        productCat("munchies", userProv, w),
                                        SizedBox(height: 10),
                                        productCat("bakery", userProv, w),
                                        SizedBox(height: 10),
                                        productCat("grooming", userProv, w),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                    // SizedBox(width: 10),
                                    Column(
                                      children: [
                                        productCat("drinks", userProv, w),
                                        SizedBox(height: 10),
                                        productCat("electronics", userProv, w),
                                        SizedBox(height: 10),
                                        productCat("daily fresh", userProv, w),
                                        SizedBox(height: 10),
                                        productCat("misc", userProv, w),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (searchResults.length != 0)
                                Positioned(
                                  top: -20,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 500,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SingleChildScrollView(
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
                        ),
                      ],
                    ),
                  ),
                ),
                Footer(
                  current: "home",
                  ctx: context,
                ),
              ],
            ),
    );
  }

  GestureDetector productCat(String img, var userProv, var w) {
    return GestureDetector(
      child: Container(
          width: w * 0.42,
          child: Image.asset(
            "assets/images/$img.png",
            fit: BoxFit.fill,
          )),
      onTap: () {
        userProv.selectedCategory = img;
        Navigator.of(context).pushNamed(ProductListScreen.routeName);
      },
    );
  }
}
