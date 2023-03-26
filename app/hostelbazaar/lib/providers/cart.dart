import 'package:flutter/material.dart';
import 'package:hostelbazaar/providers/functions.dart';

class Cart with ChangeNotifier {
  List<Map<String, dynamic>> cartItems = [];
  Map<String, int> qty = {};

  void addItem(Map<String, dynamic> item, int n) {
    if (qty.isEmpty) {
      cartItems.add(item);
      Map<String, int> entry = {
        item["_id"].toString(): n,
      };
      qty.addEntries(entry.entries);
      print("add new product!");
      return;
    }
    if (qty.containsKey(item["_id"])) {
      if (qty[item["_id"]]! + n <= item["quantity"])
        qty[item["_id"]] = qty[item["_id"]]! + n;
      else
        qty[item["_id"]] = item["quantity"];
      print("add new product!");
    } else {
      cartItems.add(item);
      Map<String, int> entry = {
        item["_id"].toString(): n,
      };
      qty.addEntries(entry.entries);
      print("add new product!");
    }
    print(qty[item["_id"]]);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    cartItems.removeWhere((element) {
      return element["_id"] == item["_id"];
    });
    qty.remove(item["_id"]);
    notifyListeners();
  }

  void increaseQty(Map<String, dynamic> item) {
    if (qty[item["_id"]]! + 1 <= item["quantity"])
      qty[item["_id"]] = qty[item["_id"]]! + 1;
    else
      qty[item["_id"]] = item["quantity"];
    notifyListeners();
  }

  void reduceQty(Map<String, dynamic> item) {
    if (qty[item["_id"]]! - 1 == 0)
      removeFromCart(item);
    else
      qty[item["_id"]] = qty[item["_id"]]! - 1;
    notifyListeners();
  }

  int getTotal() {
    int? cost = 0;
    for (int i = 0; i < cartItems.length; i++) {
      cost = (cost! + (qty[cartItems[i]["_id"]!]! * cartItems[i]["price"]!)) as int?;
    }
    return cost!;
  }

  void checkOut() async {
    print("checking out");
    List<Map<String, dynamic>> products = [];
    for (int i = 0; i < cartItems.length; i++) {
      products.add({
        "product": cartItems[i]["_id"],
        "quantity": qty[cartItems[i]["_id"]],
      });
    }
    Map<String, dynamic> checkOutData = {
      "products": products,
    };
    var res = await API().checkOut(checkOutData);
    if (res == "Unauthorized") {
      throw "err";
    }
    cartItems = [];
    qty = {};
    notifyListeners();
  }

  Future<void> buyNow(String id, int quantity) async {
    print("checking out");
    List<Map<String, dynamic>> products = [];

    Map<String, dynamic> checkOutData = {
      "products": [
        {
          "product": id,
          "quantity": quantity,
        }
      ]
    };
    await API().checkOut(checkOutData);
    notifyListeners();
  }
}
