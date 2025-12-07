// lib/domain/usecases/load_products.dart

import '../../data/repositories/product_repository.dart';
import '../../data/models/product.dart';

class LoadProducts {
  final ProductRepository repo;

  LoadProducts(this.repo);

  Future<List<Product>> call({String category = "all"}) {
    if (category == "all") {
      return repo.loadProducts();
    } else {
      return repo.loadByCategory(category);
    }
  }
}
