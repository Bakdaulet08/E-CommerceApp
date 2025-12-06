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
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    return doc.data()?["balance"] ?? 0;
  }

  // ⬆️⬆️⬆️ ПОПОЛНЕНИЕ БАЛАНСА (оставляем как было)
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () async {
              int amount = int.tryParse(amountCtrl.text) ?? 0;
              if (amount > 0) {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .update({
                  "balance": FieldValue.increment(amount),
                });

                Navigator.pop(context);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Баланс пополнен на $amount ₸")),
                );
              }
            },
            child: const Text("Пополнить"),
          ),
        ],
      ),
    );
  }

  // ⬇️⬇️⬇️ НОВОЕ — ОПЛАТА ПОКУПКИ
  Future<void> payNow(BuildContext context, List<Product> cart) async {
    int total = 0;
    for (var item in cart) {
      total += item.price.toInt();
    }

    int balance = await getBalance();

    if (balance < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Недостаточно средств! Не хватает ${(total - balance)} ₸",
          ),
        ),
      );
      return;
    }

    // списываем деньги
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "balance": FieldValue.increment(-total),
    });

    // запись в историю покупок
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("purchases")
        .add({
      "items": cart.map((e) => e.name).toList(),
      "total": total,
      "date": Timestamp.now(),
    });

    // очищаем корзину
    context.read<Shop>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Покупка успешно оплачена!")),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;

    int totalPrice = 0;
    for (var item in cart) {
      totalPrice += item.price.toInt();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: FutureBuilder<int>(
          future: getBalance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Баланс...");
            return Text("Баланс: ${snapshot.data} ₸");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_outlined),
            onPressed: () => addBalanceDialog(context),
          ),
        ],
      ),

      body: Column(
        children: [
          if (cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Общая сумма: $totalPrice ₸",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Your cart is empty.."))
                : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("${item.price} ₸"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      context.read<Shop>().removeFromCart(item);
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(50.0),
            child: MyButton(
              onTap: () => payNow(context, cart),
              child: const Text("PAY NOW"),
            ),
          ),
        ],
      ),
    );
  }
}
