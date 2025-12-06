import 'package:ecommerce_app/components/my_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          // 🔥 Kaspi-style header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFE32227), // Kaspi red
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 42, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.email ?? "Unknown User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔥 Навигационные элементы
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                MyListTile(
                  icon: Icons.store,
                  text: "Shop",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                MyListTile(
                  icon: Icons.shopping_cart,
                  text: "Cart",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cartPage');
                  },
                ),
                MyListTile(
                  icon: Icons.account_balance_wallet,
                  text: "Top Up Balance",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/balancePage');
                  },
                ),
                MyListTile(
                  icon: Icons.history,
                  text: "Purchase History",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/history');
                  },
                ),

                const Divider(height: 32),
              ],
            ),
          ),

          // 🔥 Кнопка выхода внизу
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: MyListTile(
              icon: Icons.logout,
              text: "Exit",
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/loginPage', (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
