import 'package:flutter/material.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/legal-screen/legal_screen.dart';
import 'package:hostelbazaar/palette.dart';
import 'package:hostelbazaar/sell-product-screen/sell_product_screen.dart';
import 'package:hostelbazaar/your-orders%20screen/your_orders_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Homescreen.routeName);
              },
              child: tile("Home")),
          space(),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SellProductScreen.routeName);
              },
              child: tile("Sell a product")),
          space(),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(YourOrdersScreen.routeName);
              },
              child: tile("My orders")),
          space(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(LegalScreen.routeName);
            },
            child: tile("Legal"),
          ),
          space(),
          GestureDetector(
              onTap: () async {
                const uri = 'mailto:hostelbazaar22@gmail.com?subject=HostelBazaar&body=What\'s%20up?';
                await launch(uri);
              },
              child: tile("Contact us")),
          space(),
          GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                  Uri.parse("https://forms.gle/6HgVTpYokvSXEnLf7"),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch');
                }
              },
              child: tile("Feedback")),
          space(),
        ],
      ),
    );
  }

  Text tile(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  SizedBox space() {
    return SizedBox(
      height: 10,
    );
  }
}
