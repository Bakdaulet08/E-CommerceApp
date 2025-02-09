import 'package:ecommerce_app/pages/cart_page.dart';
import 'package:ecommerce_app/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/shop.dart';
import 'themes/light_theme.dart';
import 'pages/intro_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context)=> Shop(),
      child: MyApp(),

    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode, // Используем lightMode из light_theme.dart
      home: IntroPage(),
      routes: {
        '/introPage': (context)=>const IntroPage(),
        '/shopPage': (context)=>const ShopPage(),
        '/cartPage': (context)=>const CartPage(),
      }
    );
  }
}
