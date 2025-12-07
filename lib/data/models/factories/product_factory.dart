// lib/data/models/factories/product_factory.dart
import '../product.dart';

class ProductFactory {
  /// Возвращает Product, безопасно обрабатывая null/неправильные поля
  static Product fromMap(Map<String, dynamic> data) {
    return Product.fromMap(data);
  }
}
