import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Shop extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // -------------------------------
  // 🔥 ТОВАРЫ ИЗ FIRESTORE
  // -------------------------------

  List<Product> _shop = [];
  List<Product> get shop => _shop;

  Future<void> loadProducts() async {
    try {
      final snapshot = await db.collection("products").get();

      _shop =
          snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      print("ERROR loading products: $e");
    }
  }

  // -------------------------------
  // 🛒 КОРЗИНА
  // -------------------------------

  List<Product> _cart = [];
  List<Product> get cart => _cart;

  // Загрузка корзины из Firestore
  Future<void> loadCart() async {
    try {
      final snapshot = await db
          .collection("users")
          .doc(user.uid)
          .collection("cart")
          .get();

      _cart = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data());
      }).toList();

      notifyListeners();
    } catch (e) {
      print("ERROR loading cart: $e");
    }
  }

  // Добавление товара
  Future<void> addToCart(Product item) async {
    _cart.add(item);
    notifyListeners();

    await db
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .doc(item.name) // безопасный ID
        .set({
      "name": item.name,
      "price": item.price,
      "description": item.description,
      "imageUrl": item.imageUrl,
      "category": item.category,
    });
  }

  // Удаление товара
  Future<void> removeFromCart(Product item) async {
    _cart.remove(item);
    notifyListeners();

    await db
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .doc(item.name)
        .delete();
  }

  // Очистка корзины
  Future<void> clearCart() async {
    _cart.clear();
    notifyListeners();

    final ref =
    db.collection("users").doc(user.uid).collection("cart");

    final docs = await ref.get();
    for (var doc in docs.docs) {
      await doc.reference.delete();
    }
  }
}
