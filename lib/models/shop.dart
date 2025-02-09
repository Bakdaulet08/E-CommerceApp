import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/cupertino.dart';

class Shop extends ChangeNotifier {
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

  final List<Product> _cart = []; // Это хранит товары в корзине

  // Геттер для магазина
  List<Product> get shop => _shop;

  // Геттер для корзины (исправлено)
  List<Product> get cart => _cart;

  // Добавить товар в корзину
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  // Удалить товар из корзины
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}
