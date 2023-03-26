import 'package:flutter/material.dart';
import 'package:hostelbazaar/footer.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/mainDrawer.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/your-orders%20screen/buy_orders.dart';
import 'package:hostelbazaar/your-orders%20screen/sell_orders.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class YourOrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  String selected = "buy";

  dynamic change(String status, String id) async {
    return await API().changeOrderStatus(status, id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Header(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (selected == "buy") return;
                        setState(() {
                          selected = "buy";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected == "buy" ? Color.fromRGBO(207, 193, 221, 1) : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Buy Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selected == "sell") return;
                        setState(() {
                          selected = "sell";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected == "sell" ? Color.fromRGBO(207, 193, 221, 1) : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Sell Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: selected == "buy"
                ? BuyOrders(
                    changeStatus: change,
                  )
                : SellOrders(changeStatus: change),
          ),
          Footer(
            current: "",
            ctx: context,
          ),
        ],
      ),
    );
  }
}
