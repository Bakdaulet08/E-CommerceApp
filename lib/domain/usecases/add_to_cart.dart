// lib/domain/usecases/add_to_cart.dart

import '../../data/repositories/cart_repository.dart';
import '../../data/models/product.dart';
import '../../data/models/cart_item.dart';

class AddToCart {
  final CartRepository repo;

  AddToCart(this.repo);

  Future<void> call(String uid, Product product) async {
    await repo.addToCart(uid, product);
  }
}
