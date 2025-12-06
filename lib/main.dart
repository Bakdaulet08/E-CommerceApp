import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/balance_page.dart';
import 'package:ecommerce_app/pages/cart_page.dart';
import 'package:ecommerce_app/pages/login_page.dart';
import 'package:ecommerce_app/pages/purchase_history_page.dart';
import 'package:ecommerce_app/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/shop.dart';
import 'themes/light_theme.dart';
import 'pages/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('kz');

  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      home: LoginPage(), // стартовый экран
      routes: {
        '/loginPage': (context) => LoginPage(),
        '/shopPage': (context) => ShopPage(),
        '/cartPage': (context) => CartPage(),
        '/balancePage' : (context) => BalancePage(),
        '/history': (context) => const PurchaseHistoryPage(),
      },
    );
  }
}
