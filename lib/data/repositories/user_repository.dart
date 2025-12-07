// lib/data/repositories/user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/factories/user_factory.dart';

class UserRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Получение профиля пользователя
  Future<UserProfile> loadUser(String uid) async {
    try {
      final doc = await db.collection("users").doc(uid).get();
      return UserFactory.fromMap(uid, doc.data());
    } catch (e) {
      print("🔥 ERROR: loadUser → $e");
      return UserProfile(uid: uid, email: "");
    }
  }

  /// Создать пользователя
  Future<void> createUser(UserProfile user) async {
    await db.collection("users").doc(user.uid).set(user.toMap());
  }

  /// Обновить данные
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await db.collection("users").doc(uid).update(data);
  }

  /// Пополнить баланс
  Future<void> incrementBalance(String uid, int amount) async {
    await db.collection("users").doc(uid).update({
      "balance": FieldValue.increment(amount),
    });
  }

  /// Списать деньги при покупке
  Future<void> deductBalance(String uid, int amount) async {
    await db.collection("users").doc(uid).update({
      "balance": FieldValue.increment(-amount),
    });
  }

  /// Записать покупку
  Future<void> addPurchase(
      String uid, List<String> items, int total, Map<String, String> delivery) async {
    await db
        .collection("users")
        .doc(uid)
        .collection("purchases")
        .add({
      "items": items,
      "total": total,
      "date": Timestamp.now(),
      "address": delivery["address"],
      "phone": delivery["phone"],
    });
  }
}
