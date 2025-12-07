import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String uid = "";
  int balance = 0;
  String phone = "";
  String address = "";

  Map<String, String> get deliveryData => {
    "phone": phone,
    "address": address,
  };

  // Загрузка профиля
  Future<void> loadUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    uid = user.uid;

    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    balance = data["balance"] ?? 0;
    phone = data["phone"] ?? "";
    address = data["address"] ?? "";

    notifyListeners();
  }

  // -------------------------------
  // Регистрация (для RegisterStep2)
  // -------------------------------
  Future<bool> register({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String cardNumber,
    required String cardHolder,
    required BuildContext context,
  }) async {
    try {
      UserCredential cred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      uid = cred.user!.uid;

      await _db.collection("users").doc(uid).set({
        "name": name,
        "surname": surname,
        "email": email,
        "phone": phone,
        "address": address,
        "balance": 0,
        "card": {
          "number": cardNumber,
          "holder": cardHolder,
        },
        "createdAt": DateTime.now(),
      });

      this.phone = phone;
      this.address = address;
      balance = 0;

      notifyListeners();
      return true;

    } catch (e) {
      print("REGISTER ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка регистрации: $e")),
      );
      return false;
    }
  }

  // Пополнение баланса
  Future<void> addBalance(int amount) async {
    balance += amount;

    await _db.collection("users").doc(uid).update({
      "balance": balance,
    });

    notifyListeners();
  }

  Future<void> addBalanceDialog(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Пополнить баланс"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Введите сумму"),
        ),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Пополнить"),
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              Navigator.pop(context, value);
            },
          )
        ],
      ),
    );

    if (result != null && result > 0) {
      await addBalance(result);
    }
  }

  // Обновление доставки
  Future<void> updateDelivery({
    required String phone,
    required String address,
  }) async {
    this.phone = phone;
    this.address = address;

    await _db.collection("users").doc(uid).update({
      "phone": phone,
      "address": address,
    });

    notifyListeners();
  }
  // -------------------------------------------------------
// 🔥 ЛОГИН
// -------------------------------------------------------
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      uid = cred.user!.uid;

      // загрузить профиль из Firestore
      final doc = await _db.collection("users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        balance = data["balance"] ?? 0;
        phone = data["phone"] ?? "";
        address = data["address"] ?? "";
      }

      notifyListeners();
      return true;

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка входа: $e")),
      );
      return false;
    }
  }

}
