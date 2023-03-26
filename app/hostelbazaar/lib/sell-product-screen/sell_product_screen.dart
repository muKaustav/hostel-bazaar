import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostelbazaar/header.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellProductScreen extends StatefulWidget {
  static const routeName = "/sell";

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final nameController = new TextEditingController();
  final priceController = new TextEditingController();
  final quantityController = new TextEditingController();
  final descriptionController = new TextEditingController();
  bool isLoading = false;
  String err = "";
  var userProv;
  var categoryData;
  String selectedCategory = "";
  String selectedCategoryId = "";

  File? _image;

  Future<void> initialise() async {
    setState(() {
      isLoading = true;
    });
    categoryData = await API().getCategories();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    initialise();
    super.initState();
  }

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });
  }

  void upload() async {
    setState(() {
      isLoading = true;
    });
    var userData = await API().getUserInfo();

    var data = await API().imageUpload(_image!);
    String url = data.toString().substring(13, data.toString().length - 2);
    Map<String, dynamic> body = {
      "name": nameController.text,
      "description": descriptionController.text,
      "price": priceController.text,
      "quantity": quantityController.text,
      "image": url,
      "category": selectedCategoryId,
      "hostel": userData[0]["hostel"],
      "sellerId": userData[0]["_id"],
    };

    var prodData = await API().postProduct(body);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pushNamedAndRemoveUntil(Homescreen.routeName, (route) => false);
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
                          "Product listed!",
                        ),
                      ),
                    ],
                  )),
            );
          });
        });

    setState(() {
      isLoading = false;
    });
  }

  bool check() {
    if (nameController.text.isEmpty) {
      err = "Please enter the product name!";
      return false;
    }
    if (priceController.text.isEmpty) {
      err = "Please enter the price per unit!";
      return false;
    }
    if (quantityController.text.isEmpty) {
      err = "Please enter the quantity!";
      return false;
    }
    if (descriptionController.text.isEmpty) {
      err = "Please enter product description!";
      return false;
    }
    if (_image == null) {
      err = "Please upload an image!";
      return false;
    }
    if (selectedCategory == "") {
      err = "Please select a category!";
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "List Item",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Text(
                                          "Item name: ",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: nameController,
                                              decoration: InputDecoration.collapsed(hintText: ""),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Text(
                                          "Price/unit(in ₹) : ",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              controller: priceController,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration.collapsed(
                                                hintText: "",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Text(
                                          "Quantity: ",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              controller: quantityController,
                                              decoration: InputDecoration.collapsed(
                                                hintText: "",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      child: _image == null
                                          ? Container()
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          getImage(ImageSource.camera);
                                        },
                                        child: Container(
                                          height: 42,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Image.asset("assets/images/camera.png"),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                        },
                                        child: Container(
                                          height: 42,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Image.asset("assets/images/gallery.png"),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Description: ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 100,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextField(
                            maxLines: null,
                            controller: descriptionController,
                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Center(
                                        child: Container(
                                            width: 350,
                                            height: 500,
                                            decoration: BoxDecoration(
                                              color: bgcolor,
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: primaryColor, width: 2),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    // cacheExtent: 9999,
                                                    physics: BouncingScrollPhysics(),
                                                    itemBuilder: ((ctx, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedCategory = categoryData[index]["name"];
                                                            selectedCategoryId = categoryData[index]["_id"];
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                            color: Colors.grey,
                                                          ))),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: DefaultTextStyle(
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontFamily: "Poppins",
                                                                fontSize: 16,
                                                              ),
                                                              child: Text(
                                                                categoryData[index]["name"],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    itemCount: categoryData.length,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    });
                              },
                              child: selectedCategory == ""
                                  ? Text(
                                      "Select a category",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : Text(
                                      selectedCategory,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                              ),
                              onPressed: () {
                                if (check())
                                  upload();
                                else {
                                  final snackBar = SnackBar(
                                    content: Text(err),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              child: Text(
                                "List this item",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Container inputText(String hintText, TextEditingController controller, bool password) {
    return Container(
      height: 50,
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: password ? true : false,
          decoration: InputDecoration.collapsed(
            hintText: "$hintText",
          ),
        ),
      ),
    );
  }
}
