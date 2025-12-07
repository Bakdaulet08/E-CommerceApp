// lib/data/repositories/product_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/factories/product_factory.dart';

class ProductRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Загружает все товары из Firestore → /products
  Future<List<Product>> loadProducts() async {
    try {
      final snapshot = await db.collection("products").get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['__id'] = doc.id;
        return ProductFactory.fromMap(data);
      }).toList();
    } catch (e) {
      print("🔥 ERROR: loadProducts → $e");
      return [];
    }
  }

  /// Загрузка по категории
  Future<List<Product>> loadByCategory(String category) async {
    if (category == "all") return loadProducts();

    try {
      final snapshot = await db
          .collection("products")
          .where("category", isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['__id'] = doc.id;
        return ProductFactory.fromMap(data);
      }).toList();
    } catch (e) {
      print("🔥 ERROR: loadByCategory → $e");
      return [];
    }
  }
}
