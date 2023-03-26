import 'package:flutter/material.dart';
import 'package:hostelbazaar/cart_screen/order_placed_screen.dart';
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/cart.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/providers/wishlist.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = "/productDetails";

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isLoading = true;
  var userProv;
  var wishlistProv;
  Map<String, dynamic> product = {};
  int qty = 1;

  void initialise() async {
    setState(() {
      isLoading = true;
    });
    bool details = false;
    try {
      int.parse(userProv.selectedProduct["sellerId"][0]);
      details = false;
    } catch (e) {
      details = true;
    }

    if (!details) {
      var data = await API().getSellerDetails(userProv.selectedProduct["sellerId"]);
      userProv.selectedProduct["sellerId"] = data[0];
    }

    // print(data);

    // print(userProv.selectedProduct);
    product = userProv.selectedProduct;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    wishlistProv = Provider.of<Wishlist>(context, listen: false);
    initialise();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(product);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                SizedBox(height: 20),
                Expanded(
                    child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["sellerId"]["name"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          product["name"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.maxFinite,
                            height: 300,
                            color: Colors.grey,
                            child: Image.network(
                              product["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ " + product["price"].toString(),
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  if (!wishlistProv.containsProduct(product["_id"])) {
                                    var response = await API().addToWishlist(product["_id"]);
                                    wishlistProv.addProduct(product);
                                  } else {
                                    var response = await API().removeFromWishlist(product["_id"]);
                                    wishlistProv.removeProduct(product["_id"]);
                                  }
                                },
                                child: Consumer<Wishlist>(
                                  builder: (context, value, child) => Container(child: !wishlistProv.containsProduct(product["_id"]) ? Container(height: 20, child: Image.asset("assets/images/unlike.png")) : Container(height: 20, child: Image.asset("assets/images/like.png"))),
                                ))
                          ],
                        ),
                        // Text(
                        //   "Delivery charge: ₹ 10",
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Text(
                          "In stock.",
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (qty == 1) return;
                                  setState(() {
                                    qty--;
                                  });
                                },
                                child: Container(
                                  color: secondaryColor,
                                  child: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                qty.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (qty == product["quantity"]) return;
                                  setState(() {
                                    qty++;
                                  });
                                },
                                child: Container(
                                  color: secondaryColor,
                                  child: Icon(Icons.add, color: primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var cartProv = Provider.of<Cart>(context, listen: false);
                                      await cartProv.buyNow(
                                        product["_id"],
                                        qty,
                                      );
                                      Navigator.of(context).pushReplacementNamed(OrderPlacedScreen.routeName);
                                    },
                                    child: Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      var cartProv = Provider.of<Cart>(context, listen: false);
                                      cartProv.addItem(product, qty);
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(milliseconds: 1000), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return StatefulBuilder(builder: (context, StateSetter setStat) {
                                              return Center(
                                                child: Container(
                                                    width: 200,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      color: secondaryColor,
                                                      borderRadius: BorderRadius.circular(360),
                                                      border: Border.all(color: primaryColor, width: 2),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.done,
                                                          size: 100,
                                                          color: primaryColor,
                                                        ),
                                                        DefaultTextStyle(
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontFamily: "Poppins",
                                                            fontSize: 16,
                                                          ),
                                                          child: Text(
                                                            "Added to cart!",
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              );
                                            });
                                          });
                                    },
                                    child: Text(
                                      "Add to cart",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Description",
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          product["description"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                )),
                Footer(
                  current: "",
                  ctx: context,
                )
              ],
            ),
    );
  }
}
