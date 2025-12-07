// lib/domain/observers/cart_observer.dart

abstract class CartObserver {
  void onCartUpdated(int itemCount, int totalPrice);
}

class CartLoggerObserver implements CartObserver {
  @override
  void onCartUpdated(int itemCount, int totalPrice) {
    print("🛒 Cart updated: items=$itemCount | total=$totalPrice ₸");
  }
}
