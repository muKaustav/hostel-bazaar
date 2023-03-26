import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String name = "";
  String email = "";
  String password = "";
  String contact = "";
  String upi = "";
  Map<String, dynamic> college = {};
  Map<String, dynamic> hostel = {};
  int selectedImg = -1;

  static String token = "";
  static String refreshToken = "";
  String id = "";

  String selectedPage = "home";
  dynamic lastNOrders;

  String selectedCategory = "";
  List<dynamic> selectedCategoryProductList = [];
  Map<String, dynamic> selectedProduct = {};
  int selectedProductIndex = -1;

  String selectedReviewProductId = "";

  void setToken(String t) {
    token = t;
  }

  bool get isAuth {
    return token != "";
  }

  Future<bool> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
      API.token = extractedUserData["accessToken"];
      API.refresh = extractedUserData["refreshToken"];
      print(token);
      notifyListeners();
      return true;
    }
  }

  static Future<void> updateToken(String accessToken, String rt) async {
    final prefs = await SharedPreferences.getInstance();

    final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    extractedUserData["accessToken"] = accessToken;
    extractedUserData["refreshToken"] = rt;
    prefs.setString(
        "userData",
        json.encode({
          "accessToken": accessToken,
          "refreshToken": rt,
        }));
    token = accessToken;
    refreshToken = rt;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userData");
  }
}
