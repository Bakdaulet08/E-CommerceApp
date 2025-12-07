import 'package:flutter/material.dart';
import '../../data/models/product.dart';

import '../../domain/usecases/load_products.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/process_purchase.dart';
import '../../domain/usecases/load_history.dart';

import '../../domain/observers/cart_observer.dart';
import '../../data/models/purchase_history.dart';

class ShopProvider extends ChangeNotifier {
  final LoadProducts loadProductsUC;
  final AddToCart addToCartUC;
  final RemoveFromCart removeFromCartUC;
  final ProcessPurchase processPurchaseUC;
  final LoadHistory loadHistoryUC;
  final CartObserver observer;

  ShopProvider({
    required this.loadProductsUC,
    required this.addToCartUC,
    required this.removeFromCartUC,
    required this.processPurchaseUC,
    required this.loadHistoryUC,
    required this.observer,
  });

  // -----------------------
  // 📌 ТОВАРЫ
  // -----------------------
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    _products = await loadProductsUC();
    notifyListeners();
  }

  // -----------------------
  // 🛒 КОРЗИНА
  // -----------------------
  List<Product> _cart = [];
  List<Product> get cart => _cart;

  int get cartTotal =>
      _cart.fold(0, (sum, item) => sum + item.price.toInt());

  // ➕ Добавление
  Future<void> addToCart(String uid, Product product) async {
    await addToCartUC(uid, product);

    _cart.add(product);

    observer.onCartUpdated(_cart.length, cartTotal);
    notifyListeners();
  }

  // ❌ Удаление
  Future<void> remove(String uid, Product product) async {
    await removeFromCartUC(uid, product);

    _cart.remove(product);

    observer.onCartUpdated(_cart.length, cartTotal);
    notifyListeners();
  }

  // -----------------------
  // 💳 Покупка
  // -----------------------
  Future<bool> purchase(
      String uid,
      int balance,
      Map<String, String> delivery,
      BuildContext context,
      ) async {

    final error = await processPurchaseUC(
      uid,
      _cart,
      delivery,
      balance,
    );

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return false;
    }

    // Успех → очищаем корзину
    _cart.clear();
    notifyListeners();
    return true;
  }

  // -----------------------
  // 📜 История покупок
  // -----------------------
  Future<List<PurchaseHistory>> loadHistory(String uid) async {
    return await loadHistoryUC(uid);
  }
}
