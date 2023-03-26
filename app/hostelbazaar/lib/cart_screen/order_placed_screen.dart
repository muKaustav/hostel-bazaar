import "package:flutter/material.dart";
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/review_screen/review_screen.dart';
import 'package:hostelbazaar/your-orders%20screen/your_orders_screen.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  static const routeName = "/success";

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  bool isLoading = true;
  var userProv;
  var data;

  void initialiseData() async {
    data = await API().getLastOrderUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    initialiseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(Homescreen.routeName, (route) => false);
        return false;
      },
      child: Scaffold(
        drawer: MainDrawer(),
        backgroundColor: bgcolor,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Column(
                children: [
                  Header(),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Order Placed!",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Order Details: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              // height: 220,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: bgLite,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...data[0].map((seller) {
                                    print(data[3]);
                                    return Container(
                                      // height: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...data[1][seller].map((element) {
                                            print("element!!!!!!");
                                            print(element);
                                            return Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        element["product"]["name"].toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "x " + element["quantity"].toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      userProv.selectedReviewProductId = element["product"]["_id"].toString();
                                                      Navigator.of(context).pushNamed(ReviewScreen.routeName);
                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        "write a review",
                                                        style: TextStyle(
                                                          decoration: TextDecoration.underline,
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          Container(
                                            width: double.maxFinite,
                                            child: Divider(
                                              color: mainColor,
                                              thickness: 2,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Sub total: ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                "₹ " + data[3][seller].toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Seller Name: " + data[2][seller]["name"].toString(),
                                            style: sellerStyle(),
                                          ),
                                          Text(
                                            "Seller UPI: " + data[2][seller]["UPI"].toString(),
                                            style: sellerStyle(),
                                          ),
                                          Text(
                                            "Seller Contact: " + data[2][seller]["contact"].toString(),
                                            style: sellerStyle(),
                                          ),
                                          Text(
                                            "Seller Room Number: " + data[2][seller]["room_number"].toString(),
                                            style: sellerStyle(),
                                          ),
                                          Text(
                                            "Seller Hostel: " + data[2][seller]["hostel"]["name"].toString(),
                                            style: sellerStyle(),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(YourOrdersScreen.routeName);
                              },
                              child: Text(
                                "Go to Orders",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Footer(
                    current: "",
                    ctx: context,
                  ),
                ],
              ),
      ),
    );
  }

  TextStyle sellerStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
  }
}
