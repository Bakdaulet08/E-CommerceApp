import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  // 🔥 Диалог пополнения — UI остаётся в UI слое
  Future<void> _showAddBalanceDialog(BuildContext context) async {
    final controller = TextEditingController();
    final user = context.read<UserProvider>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Пополнить баланс"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Сумма"),
        ),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Пополнить"),
            onPressed: () async {
              final amount = int.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                await user.addBalance(amount);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE32227),
      appBar: AppBar(
        title: const Text("Баланс", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Карточка баланса
            Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text("Ваш баланс",
                      style: TextStyle(color: Colors.black54, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(
                    "${user.balance} ₸",
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Кнопка пополнить
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFE32227),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showAddBalanceDialog(context),
              child: const Text(
                "Пополнить",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
