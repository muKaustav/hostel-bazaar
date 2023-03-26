import 'package:flutter/material.dart';
import 'package:hostelbazaar/empty.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:intl/intl.dart';

class SellOrders extends StatefulWidget {
  Function changeStatus;

  SellOrders({required this.changeStatus});

  @override
  State<SellOrders> createState() => _SellOrdersState();
}

class _SellOrdersState extends State<SellOrders> {
  bool isLoading = true;
  late List<dynamic> dataSell;

  void update(String newUpdate, String id) async {
    setState(() {
      isLoading = true;
    });
    var data = await widget.changeStatus(newUpdate, id);
    getSellData();
  }

  void getSellData() async {
    setState(() {
      isLoading = true;
    });
    dataSell = await API().getPendingOrders();
    dataSell = new List.from(dataSell.reversed);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getSellData();
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
          : dataSell.isEmpty
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: Image.network(
                                  dataSell[index]["items"][0]["product"]["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                dataSell[index]["items"].length > 1
                                    ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            dataSell[index]["items"][0]["product"]["name"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            " +" + (dataSell[index]["items"].length - 1).toString() + " others",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      )
                                    : Text(
                                        dataSell[index]["items"][0]["product"]["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                Text(
                                  "Order placed on " + DateFormat("dd MMMM, yyyy").format(DateTime.parse(dataSell[index]["createdAt"])),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mainColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(253, 138, 138, 1),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          update("cancelled", dataSell[index]["_id"]);
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(181, 241, 204, 1),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          update("completed", dataSell[index]["_id"]);
                                        },
                                        icon: Icon(Icons.done),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                    itemCount: dataSell.length,
                    padding: EdgeInsets.all(0),
                  ),
                ),
    );
  }
}
