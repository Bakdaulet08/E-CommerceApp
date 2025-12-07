import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/my_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<Map<String, String>?> editDeliveryDialog(
      BuildContext context, Map<String, String> initialData) async {
    final phone = TextEditingController(text: initialData["phone"]);
    final address = TextEditingController(text: initialData["address"]);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Доставка"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Телефон"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: address,
              decoration: const InputDecoration(labelText: "Адрес"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Сохранить"),
            onPressed: () => Navigator.pop(context, {
              "phone": phone.text,
              "address": address.text,
            }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final user = context.watch<UserProvider>();

    final cart = shop.cart;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          "Баланс: ${user.balance} ₸",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE32227),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_outlined, color: Colors.white),
            onPressed: () => user.addBalanceDialog(context),
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
                  const Text("Итого:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "${shop.cartTotal} ₸",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Корзина пуста"))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.length,
              itemBuilder: (_, i) {
                final item = cart[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text("${item.price} ₸",
                                style:
                                const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => shop.remove(
                          user.uid,
                          item,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: MyButton(
                onTap: () async {
                  // 🔥 диалог доставки
                  final delivery =
                  await editDeliveryDialog(context, user.deliveryData);

                  if (delivery == null) return;

                  // обновить доставку
                  await user.updateDelivery(
                    phone: delivery["phone"]!,
                    address: delivery["address"]!,
                  );

                  // 🔥 попытка покупки
                  final ok = await shop.purchase(
                    user.uid,
                    user.balance,
                    user.deliveryData,
                    context,
                  );

                  if (ok) {
                    await user.loadUser(); // 🔥 обновляем баланс после транзакции
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Оплата успешно выполнена")),
                    );
                  }
                },
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
