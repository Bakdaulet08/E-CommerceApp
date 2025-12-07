import '../../data/repositories/user_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../data/models/product.dart';

class ProcessPurchase {
  final PurchaseRepository purchaseRepo;
  final UserRepository userRepo;
  final CartRepository cartRepo;

  ProcessPurchase({
    required this.purchaseRepo,
    required this.userRepo,
    required this.cartRepo,
  });

  Future<String?> call(
      String uid,
      List<Product> cart,
      Map<String, String> delivery,
      int currentBalance,
      ) async {
    final total = cart.fold(0, (sum, item) => sum + item.price.toInt());

    if (currentBalance < total) {
      return "Недостаточно средств: не хватает ${total - currentBalance} ₸";
    }

    // списываем деньги
    await userRepo.deductBalance(uid, total);

    // сохраняем историю
    await purchaseRepo.savePurchase(
      uid: uid,
      items: cart.map((e) => e.name).toList(),
      total: total,
      delivery: delivery,
    );

    // чистим корзину
    await cartRepo.clearCart(uid);

    return null; // успех
  }
}
