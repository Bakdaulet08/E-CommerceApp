import '../../data/models/purchase_history.dart';
import '../../data/repositories/purchase_repository.dart';

class LoadHistory {
  final PurchaseRepository repo;

  LoadHistory(this.repo);

  Future<List<PurchaseHistory>> call(String uid) {
    return repo.loadHistory(uid);
  }
}
