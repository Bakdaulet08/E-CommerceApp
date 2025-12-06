import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<int> getBalance() async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    return doc.data()?["balance"] ?? 0;
  }

  Future<void> addBalanceDialog() async {
    TextEditingController amountCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Пополнить баланс"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Сумма"),
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
              }
            },
            child: const Text("Пополнить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE32227),
      appBar: AppBar(
        title: const Text("Баланс", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE32227),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder<int>(
          future: getBalance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(color: Colors.white);
            }

            int balance = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Красная карточка с балансом
                Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Ваш баланс",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$balance ₸",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Кнопка пополнить
                ElevatedButton(
                  onPressed: addBalanceDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE32227),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Пополнить",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
