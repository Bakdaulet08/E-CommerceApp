import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final purchasesRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("purchases")
        .orderBy("date", descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFFE32227),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("История покупок"),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: purchasesRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "Пока нет покупок",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                var data = docs[i].data() as Map<String, dynamic>;

                List items = data["items"];
                int total = data["total"];
                DateTime date = data["date"].toDate();

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Дата
                      Text(
                        DateFormat("dd MMM yyyy, HH:mm", "ru").format(date),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),

                      // Список товаров
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items.map((item) {
                          return Text(
                            "• $item",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Итоговая сумма
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE32227),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$total ₸",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
