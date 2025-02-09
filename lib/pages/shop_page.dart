import 'package:ecommerce_app/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_product_tile.dart';
import '../models/shop.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {

    final products = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shop Page'),
        actions:[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cartPage'),
            icon: Icon(Icons.shopping_cart)
          )
        ]
      ),
      drawer: MyDrawer(

      ),
      body: ListView(
        children:[
          Center(
              child: Text("Pick from a selected list of premium products",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),

          ),
          SizedBox(
          height: 550,
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];

              return MyProductTile(product: product);
            }
          ),
        ),]
      )
    );
  }
}
