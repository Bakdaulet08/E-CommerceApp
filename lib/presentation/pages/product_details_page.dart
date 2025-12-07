import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../providers/shop_provider.dart';
import '../providers/user_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final shop = context.read<ShopProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),

            const SizedBox(height: 8),

            Text(
              "${product.price.toStringAsFixed(0)} ₸",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              product.description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await shop.addToCart(user.uid, product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Добавлено в корзину")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("В корзину"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
