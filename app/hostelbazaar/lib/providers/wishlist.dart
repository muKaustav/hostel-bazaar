import 'package:flutter/material.dart';

class Wishlist with ChangeNotifier {
  List<dynamic> wishlist = [];

  void addProduct(Map<String, dynamic> product) {
    wishlist.add({"product": product});
    notifyListeners();
  }

  void removeProduct(String id) {
    wishlist.removeWhere((element) => element["product"]["_id"] == id);
    notifyListeners();
  }

  bool containsProduct(String id) {
    int res = wishlist.indexWhere((element) => element["product"]["_id"] == id);
    if (res == -1) return false;
    return true;
  }
}
