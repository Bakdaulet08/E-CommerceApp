import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Shop extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Локальный список товаров
  final List<Product> _shop = [
    Product(
      name: "Creatine",
      price: 7850,
      description: "After taking this you will see the result immediately",
      imagePath: "lib/assets/qazCreatine.png",
    ),
    Product(
      name: "Protein",
      price: 15350,
      description: "Undoubtedly this product helps you to get mass",
      imagePath: "lib/assets/protein.png",
    ),
    Product(
      name: "Gainer",
      price: 9420,
      description: "Item description..",
      imagePath: "lib/assets/gainer.png",
    ),
    Product(
      name: "Dumbbell set",
      price: 20350,
      description: "Item description..",
      imagePath: "lib/assets/dumbbell.png",
    ),
  ];

  List<Product> get shop => _shop;

  // Корзина
  List<Product> _cart = [];
  List<Product> get cart => _cart;

  // ---------- Firestore интеграция ----------

  // Загружаем корзину из Firestore
  Future<void> loadCart() async {
    var snapshot = await db
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .get();

    _cart = snapshot.docs.map((doc) {
      var data = doc.data();
      return Product(
        name: data["name"],
        price: data["price"],
        imagePath: data["imagePath"],
        description: data["description"],
      );
    }).toList();

    notifyListeners();
  }

  // Добавить в корзину (локально + Firestore)
  Future<void> addToCart(Product item) async {
    _cart.add(item);
    notifyListeners();

    await db
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .doc(item.name) // имя — уникальный ID
        .set({
      "name": item.name,
      "price": item.price,
      "description": item.description,
      "imagePath": item.imagePath,
    });
  }

  // Удалить товар
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

  // Очистить корзину
  Future<void> clearCart() async {
    _cart.clear();
    notifyListeners();

    var ref = db.collection("users").doc(user.uid).collection("cart");

    var docs = await ref.get();
    for (var doc in docs.docs) {
      await doc.reference.delete();
    }
  }
}
