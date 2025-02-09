import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<Shop>().cart;


    void removeItemFromCart(BuildContext context, Product product){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
          AlertDialog(
            content: Text("Remove this item from your cart?"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                context.read<Shop>().removeFromCart(product);},
                child: const Text("Yes"),
              )
            ]

          );
        },


      );
    }
    void payButtonPressed(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            "User wants to pay! Connect this app to your payment backend",
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        foregroundColor:Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart Page"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children:[
          Expanded(
            child: cart.isEmpty? const Center(child:Text("Your cart is empty..")):ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.price.toStringAsFixed(2)),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: ()=> removeItemFromCart(context, item),
                  )
                );
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: MyButton(
              onTap: () => payButtonPressed(context), // Передаем функцию как замыкание
              child: Text("PAY NOW"),
            ),
          ),        ]
      )
    );
  }
}
