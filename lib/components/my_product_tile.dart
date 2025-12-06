import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/shop.dart';

class MyProductTile extends StatelessWidget {
  final Product product;
  const MyProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // 📌 Большая картинка
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1, // квадратная = ровная, большая
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // 📌 Название
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          // 📌 Цена
          Text(
            "${product.price.toStringAsFixed(0)} ₸",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // 📌 Кнопка
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () {
                context.read<Shop>().addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Добавлено в корзину")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                "В корзину",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
