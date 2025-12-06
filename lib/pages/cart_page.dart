import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../models/product.dart';
import '../models/shop.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<int> getBalance() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    return doc.data()?["balance"] ?? 0;
  }

  Future<Map<String, String>> getUserInfo() async {
    var doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    return {
      "phone": doc["phone"] ?? "",
      "address": doc["address"] ?? "",
    };
  }

  // 🔥 Изменение адреса и номера перед покупкой
  Future<Map<String, String>?> editDeliveryDialog() async {
    final data = await getUserInfo();
    final phoneCtrl = TextEditingController(text: data["phone"]);
    final addressCtrl = TextEditingController(text: data["address"]);

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Данные доставки"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Номер телефона"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Адрес доставки"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Отмена", style: TextStyle(color: Colors.black54),),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Сохранить", style: TextStyle(color: Colors.black54),),
            onPressed: () {
              Navigator.pop(context, {
                "phone": phoneCtrl.text,
                "address": addressCtrl.text,
              });
            },
          ),
        ],
      ),
    );
  }

  // 🔥 Пополнение баланса
  Future<void> addBalanceDialog(BuildContext context) async {
    TextEditingController amountCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Пополнить баланс"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Введите сумму"),
        ),
        actions: [
          TextButton(
            child: const Text("Отмена", style: TextStyle(color: Colors.black54)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Пополнить", style: TextStyle(color: Colors.black54)),
            onPressed: () async {
              int amount = int.tryParse(amountCtrl.text) ?? 0;

              if (amount > 0) {
                await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                  "balance": FieldValue.increment(amount),
                });

                Navigator.pop(context);
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  // 🔥 Оплата покупки
  Future<void> payNow(BuildContext context, List<Product> cart) async {
    int total = cart.fold(0, (sum, item) => sum + item.price.toInt());
    int balance = await getBalance();

    if (balance < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Недостаточно средств! Не хватает ${total - balance} ₸")),
      );
      return;
    }

    // ➜ спрашиваем номер + адрес
    final deliveryData = await editDeliveryDialog();
    if (deliveryData == null) return;

    // сохраняем новые данные
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "phone": deliveryData["phone"],
      "address": deliveryData["address"],
    });

    // ➜ списываем деньги
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "balance": FieldValue.increment(-total),
    });

    // ➜ записываем историю
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("purchases")
        .add({
      "items": cart.map((e) => e.name).toList(),
      "total": total,
      "date": Timestamp.now(),
      "address": deliveryData["address"],
      "phone": deliveryData["phone"],
    });

    // ➜ очищаем корзину
    context.read<Shop>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Покупка успешно оплачена!")),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;

    final total = cart.fold(0, (sum, item) => sum + item.price.toInt());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE32227),
        centerTitle: true,
        title: FutureBuilder<int>(
          future: getBalance(),
          builder: (context, snap) {
            if (!snap.hasData) return const Text("Баланс…", style: TextStyle(color: Colors.white));
            return Text("Баланс: ${snap.data} ₸", style: const TextStyle(color: Colors.white));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_outlined, color: Colors.white),
            onPressed: () => addBalanceDialog(context),
          )
        ],
      ),

      body: Column(
        children: [
          if (cart.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Итого:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("$total ₸", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Корзина пуста"))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // картинка товара
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // текст
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("${item.price} ₸",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          context.read<Shop>().removeFromCart(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                onTap: () => payNow(context, cart),
                child: const Text(
                  "ОПЛАТИТЬ",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
