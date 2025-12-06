import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/shop.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Большое фото товара
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.imageUrl,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Название
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 Цена
            Text(
              "${product.price.toStringAsFixed(0)} ₸",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Описание
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 Кнопка "Добавить в корзину"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  context.read<Shop>().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Товар добавлен в корзину"),
                    ),
                  );
                },
                child: const Text(
                  "Добавить в корзину",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
