import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/shop.dart';

class MyProductTile extends StatelessWidget {
  const MyProductTile({super.key, required this.product});

  final Product product;

  void addToCart(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Add this item to your cart?"),
        actions:[
          ElevatedButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text("Cancel")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().addToCart(product);
              },
            child: Text("Add")
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),

      ),
      width: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children:[
              AspectRatio(
                aspectRatio:1,
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,

                    ),
                    width: double.infinity,
                    // padding: EdgeInsets.all(25),
                    child: Image.asset(product.imagePath),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                  product.name,
                  style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize: 20
                  )
              ),
              const SizedBox(height: 10),
              Text(product.description),
              const SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${product.price.toStringAsFixed(2)}tg"),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: IconButton(
                      onPressed: ()=> addToCart(context),
                      icon: const Icon(Icons.add),
                    )
                  )
                ],
              ),


            ]
          )
        ]
      )
    );
  }
}
