import 'package:flutter/material.dart';
import 'package:hostelbazaar/empty.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:intl/intl.dart';

class BuyOrders extends StatefulWidget {
  Function changeStatus;

  BuyOrders({required this.changeStatus});
  @override
  State<BuyOrders> createState() => _BuyOrdersState();
}

class _BuyOrdersState extends State<BuyOrders> {
  bool isLoading = true;
  late List<dynamic> dataBuy;

  void update(String id) async {
    setState(() {
      isLoading = true;
    });
    var data = await widget.changeStatus("cancelled", id);
    getBuyData();
  }

  void getBuyData() async {
    setState(() {
      isLoading = true;
    });
    dataBuy = await API().getPreviousOrders();
    dataBuy = new List.from(dataBuy.reversed);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getBuyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : dataBuy.isEmpty
              ? Empty()
              : Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return Container(
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
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: Image.network(
                                  dataBuy[index]["items"][0]["product"]["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  dataBuy[index]["items"].length > 1
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              dataBuy[index]["items"][0]["product"]["name"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              " +" + (dataBuy[index]["items"].length - 1).toString() + " others",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          dataBuy[index]["items"][0]["product"]["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                  Text(
                                    "Order placed on " + DateFormat("dd MMMM, yyyy").format(DateTime.parse(dataBuy[index]["createdAt"])),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: mainColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Status: " + dataBuy[index]["status"],
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                      if (dataBuy[index]["status"] == "pending")
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(253, 138, 138, 1),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              update(dataBuy[index]["_id"]);
                                            },
                                            icon: Icon(Icons.close),
                                            iconSize: 20,
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    itemCount: dataBuy.length,
                    padding: EdgeInsets.all(0),
                  ),
                ),
    );
  }
}
