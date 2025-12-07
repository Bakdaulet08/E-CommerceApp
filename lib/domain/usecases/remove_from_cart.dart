import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repo;

  RemoveFromCart(this.repo);

  Future<void> call(String uid, Product product) {
    return repo.removeFromCart(uid, product.name);
  }
}
