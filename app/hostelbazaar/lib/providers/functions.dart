import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostelbazaar/providers/tokens.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/signup-login%20screen/login_screen.dart';
import 'package:hostelbazaar/url.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class API {
  static String refresh = "";
  static String token = "";
  static late BuildContext context;

  dynamic refreshToken() async {
    String callUrl = "$URL/auth/refresh";
    final response = await http.post(
      Uri.parse(callUrl),
      body: {
        "token": refresh,
      },
    );
    print(response.body);
    var data = jsonDecode(response.body);
    if (data["success"] == false) {
      token = "";
      refresh = "";
      await User().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      return;
    }
    refresh = data["refreshToken"];
    token = data["accessToken"].toString().substring(7);

    await User.updateToken(token, refresh);
  }

  dynamic login(String email, String password) async {
    String callUrl = "$URL/auth/login";
    final response = await http.post(
      Uri.parse(callUrl),
      body: {
        "email": email,
        "password": password,
      },
    );
    print(response.body);
    var data = jsonDecode(response.body);
    return data;
  }

  dynamic getLastNOrders() async {
    String callUrl = "$URL/order/last/10";
    final response = await http.get(
      Uri.parse(callUrl),
      headers: {
        "Authorization": "Bearer ${token}",
      },
    );
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getLastNOrders();
    }
    var data = jsonDecode(response.body);
    return data;
  }

  dynamic getProductsByCategory(String category) async {
    String callUrl = "$URL/product/category/$category";
    final response = await http.get(
      Uri.parse(callUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getProductsByCategory(category);
    }
    var data = jsonDecode(response.body);
    return data;
  }

  dynamic checkOut(Map<String, dynamic> checkOutData) async {
    String callUrl = "$URL/product/buy";
    var postData = json.encode(checkOutData);
    print(postData);
    final response = await http.post(
      Uri.parse(callUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: postData,
    );
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return checkOut(checkOutData);
    }
    var data = jsonDecode(response.body);
    return data;
  }

  dynamic getPreviousOrders() async {
    String callUrl = "$URL/order/me";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getPreviousOrders();
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic searchProduct(String search) async {
    String callUrl = "$URL/product/searchUnique/$search";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return searchProduct(search);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic searchUniqueProduct(String search) async {
    String callUrl = "$URL/product/search/$search";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return searchUniqueProduct(search);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getLastOrderUser() async {
    String callUrl = "$URL/order/user/last/0";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    var data = json.decode(response.body);

    if (response.body == "Unauthorized") {
      await refreshToken();
      return getLastOrderUser();
    }

    List<String> sellers = [];
    Map<String, dynamic> sellerDetails = {};
    Map<String, dynamic> orders = {};
    Map<String, int> total = {};

    for (int i = 0; i < data[0]["items"].length; i++) {
      var curr = data[0]["items"][i];
      if (orders.isNotEmpty && orders.containsKey(curr["product"]["sellerId"]["_id"])) {
        orders[curr["product"]["sellerId"]["_id"]]!.add(curr);
        total[curr["product"]["sellerId"]["_id"]] = total[curr["product"]["sellerId"]["_id"]]! + (int.parse(curr["product"]["price"].toString()) * int.parse(curr["quantity"].toString()));
        continue;
      }

      orders.addAll({
        curr["product"]["sellerId"]["_id"]: [curr]
      });
      total.addAll({curr["product"]["sellerId"]["_id"]: (int.parse(curr["product"]["price"].toString()) * int.parse(curr["quantity"].toString()))});
      sellerDetails.addAll({curr["product"]["sellerId"]["_id"]: curr["product"]["sellerId"]});
      sellers.add(curr["product"]["sellerId"]["_id"]);
    }
    print(orders);

    return [sellers, orders, sellerDetails, total];
  }

  dynamic addToWishlist(String id) async {
    String callUrl = "$URL/profile/saved/add";
    final response = await http.post(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "itemId": id,
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return addToWishlist(id);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getWishlist() async {
    String callUrl = "$URL/profile/saved/me";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getWishlist();
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic removeFromWishlist(String id) async {
    String callUrl = "$URL/profile/saved/rm";
    final response = await http.post(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "itemId": id,
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return removeFromWishlist(id);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic rateProduct(String prodId, double rating, String comment, String userid) async {
    String callUrl = "$URL/product/review/single";
    final response = await http.post(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "productId": prodId,
      "rating": rating.toString(),
      "comment": comment,
      "userId": userid,
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return rateProduct(prodId, rating, comment, userid);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic sendOtp(String number) async {
    String callUrl = "$URL/otp/send-otp";
    final response = await http.post(Uri.parse(callUrl), body: {
      "number": number,
    });
    print(response.body);
    var data = json.decode(response.body);
    return data;
  }

  dynamic verifyOtp(String number, String otp) async {
    String callUrl = "$URL/otp/verify-otp";
    final response = await http.post(
      Uri.parse(callUrl),
      body: {
        "number": number,
        "otp": otp,
      },
    );
    print(response.body);
    var data = json.decode(response.body);
    return data;
  }

  dynamic getColleges() async {
    String callUrl = "$URL/admin/college/all";
    final response = await http.get(
      Uri.parse(callUrl),
    );
    print(response.body);
    var data = json.decode(response.body);
    return data;
  }

  dynamic getHostels(String id) async {
    String callUrl = "$URL/admin/hostel/all?collegeId=" + id;
    final response = await http.get(
      Uri.parse(callUrl),
    );
    print(response.body);
    var data = json.decode(response.body);
    return data;
  }

  dynamic signUp(Map<String, String> body) async {
    String callUrl = "$URL/auth/signup";
    final response = await http.post(Uri.parse(callUrl), body: body);
    print(response.body);
    var data = json.decode(response.body);
    return data;
  }

  dynamic imageUpload(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$URL/s3/image-upload"),
    );
    Map<String, String> headers = {"Authorization": "Bearer $token", "Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "prod.jpg",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    print(request.toString());
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    if (respStr == "Unauthorized") {
      await refreshToken();
      return imageUpload(file);
    }
    return respStr;
  }

  dynamic getUserInfo() async {
    String callUrl = "$URL/profile/user/me";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getUserInfo();
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic postProduct(Map<String, dynamic> body) async {
    String callUrl = "$URL/product";
    final response = await http.post(Uri.parse(callUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return postProduct(body);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getCategories() async {
    String callUrl = "$URL/admin/category/all";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getCategories();
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getSellerDetails(String id) async {
    String callUrl = "$URL/profile/user/$id";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getSellerDetails(id);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getPendingOrders() async {
    String callUrl = "$URL/order/pending";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getPendingOrders();
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic changeOrderStatus(String status, String id) async {
    String callUrl = "$URL/order/editStatus";
    final response = await http.put(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    }, body: {
      "status": status,
      "orderId": id,
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return changeOrderStatus(status, id);
    }
    var data = json.decode(response.body);
    return data;
  }

  dynamic getVersion() async {
    String callUrl = "$URL/admin/version/current";
    final response = await http.get(Uri.parse(callUrl), headers: {
      "Authorization": "Bearer $token",
    });
    print(response.body);
    if (response.body == "Unauthorized") {
      await refreshToken();
      return getVersion();
    }
    var data = json.decode(response.body);
    return data;
  }
}
