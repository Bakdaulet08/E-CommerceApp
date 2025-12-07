// lib/data/repositories/cart_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/factories/product_factory.dart';

class CartRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Загрузка корзины: /users/{uid}/cart
  Future<List<CartItem>> loadCart(String uid) async {
    try {
      final snapshot =
      await db.collection("users").doc(uid).collection("cart").get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['__id'] = doc.id;
        return CartItem.fromMap(data);
      }).toList();
    } catch (e) {
      print("🔥 ERROR: loadCart → $e");
      return [];
    }
  }

  /// Добавить товар
  Future<void> addToCart(String uid, Product product,
      {int quantity = 1}) async {
    await db
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(product.name)
        .set({
      ...product.toMap(),
      "quantity": quantity,
    });
  }

  /// Удалить товар
  Future<void> removeFromCart(String uid, String productId) async {
    await db
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  /// Очистить корзину
  Future<void> clearCart(String uid) async {
    final ref = db.collection("users").doc(uid).collection("cart");
    final docs = await ref.get();
    for (var d in docs.docs) {
      await d.reference.delete();
    }
  }
}
