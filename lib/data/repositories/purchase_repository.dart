import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/purchase_history.dart';

abstract class PurchaseRepository {
  Future<void> savePurchase({
    required String uid,
    required List<String> items,
    required int total,
    required Map<String, String> delivery,
  });

  Future<List<PurchaseHistory>> loadHistory(String uid);
}

class PurchaseRepositoryImpl implements PurchaseRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<void> savePurchase({
    required String uid,
    required List<String> items,
    required int total,
    required Map<String, String> delivery,
  }) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("purchases")
        .add({
      "items": items,
      "total": total,
      "phone": delivery["phone"],
      "address": delivery["address"],
      "date": Timestamp.now(),
    });
  }

  @override
  Future<List<PurchaseHistory>> loadHistory(String uid) async {
    final snap = await _db
        .collection("users")
        .doc(uid)
        .collection("purchases")
        .orderBy("date", descending: true)
        .get();

    return snap.docs
        .map((doc) => PurchaseHistory.fromMap(doc.data()))
        .toList();
  }
}
