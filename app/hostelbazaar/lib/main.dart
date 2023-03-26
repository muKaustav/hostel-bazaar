import 'package:flutter/material.dart';
import 'package:hostelbazaar/busy.dart';
import 'package:hostelbazaar/cart_screen/cart_screen.dart';
import 'package:hostelbazaar/cart_screen/order_placed_screen.dart';
import 'package:hostelbazaar/homescreen/homescreen.dart';
import 'package:hostelbazaar/legal-screen/legal_screen.dart';
import 'package:hostelbazaar/product-list%20screen/product_details_screen.dart';
import 'package:hostelbazaar/product-list%20screen/product_list_screen.dart';
import 'package:hostelbazaar/providers/cart.dart';
import 'package:hostelbazaar/providers/functions.dart';
import 'package:hostelbazaar/providers/user.dart';
import 'package:hostelbazaar/providers/wishlist.dart';
import 'package:hostelbazaar/review_screen/review_screen.dart';
import 'package:hostelbazaar/search-screen/search_screen.dart';
import 'package:hostelbazaar/sell-product-screen/sell_product_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/details_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/hostel_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/login_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/otp_screen.dart';
import 'package:hostelbazaar/signup-login%20screen/signup_screen.dart';
import 'package:hostelbazaar/splash_screen.dart';
import 'package:hostelbazaar/user-profile-screen/user_profile_screen.dart';
import 'package:hostelbazaar/wishlist_screen/wishlist_screen.dart';
import 'package:hostelbazaar/your-orders%20screen/your_orders_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => User()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Wishlist()),
      ],
      child: Consumer<User>(
        builder: (ctx, user, _) {
          return MaterialApp(
            title: 'Hostel Bazaar',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              fontFamily: "Poppins",
            ),
            home: API.token != ""
                ? Homescreen()
                : FutureBuilder(
                    future: user.checkUser(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : LoginScreen(),
                  ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SignupScreen.routeName: (ctx) => SignupScreen(),
              Homescreen.routeName: (ctx) => Homescreen(),
              ProductListScreen.routeName: (ctx) => ProductListScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderPlacedScreen.routeName: (ctx) => OrderPlacedScreen(),
              YourOrdersScreen.routeName: (ctx) => YourOrdersScreen(),
              SearchScreen.routeName: (ctx) => SearchScreen(),
              WishlistScreen.routeName: (ctx) => WishlistScreen(),
              ReviewScreen.routeName: (ctx) => ReviewScreen(),
              DetailsScreen.routeName: (ctx) => DetailsScreen(),
              OTPScreen.routeName: (ctx) => OTPScreen(),
              HostelScreen.routeName: (ctx) => HostelScreen(),
              SellProductScreen.routeName: (ctx) => SellProductScreen(),
              LegalScreen.routeName: (ctx) => LegalScreen(),
              UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
              BusyScreen.routeName: (ctx) => BusyScreen(),
            },
          );
        },
      ),
    );
  }
}
