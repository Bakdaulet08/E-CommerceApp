// lib/data/models/cart_item.dart
import 'product.dart';

class CartItem {
  final String id; // можно хранить id продукта или docId в users/{uid}/cart
  final Product product;
  final int quantity;

  CartItem({this.id = '', required this.product, this.quantity = 1});

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      id: (data['__id'] ?? data['id'] ?? '') as String,
      product: Product.fromMap(data),
      quantity: (data['quantity'] is int) ? data['quantity'] as int : int.tryParse('${data['quantity']}') ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    final m = product.toMap();
    m['quantity'] = quantity;
    return m;
  }
}
