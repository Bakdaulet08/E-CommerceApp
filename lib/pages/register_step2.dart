import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/shop_page.dart';

class RegisterStep2 extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String password;

  const RegisterStep2({
    super.key,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cardNumberCtrl = TextEditingController();
  final cardHolderCtrl = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _registerFinal() async {
    try {
      UserCredential cred =
      await auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": widget.name,
        "surname": widget.surname,
        "email": widget.email,
        "phone": phoneCtrl.text.trim(),
        "address": addressCtrl.text.trim(),
        "balance": 0,
        "createdAt": Timestamp.now(),
        "card": {
          "number": cardNumberCtrl.text.trim(),
          "holder": cardHolderCtrl.text.trim(),
        },
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShopPage()),
      );
    } catch (e) {
      print("REG ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE32227),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              Image.asset("lib/assets/kaspi_logo.png", height: 90),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    TextField(
                      controller: phoneCtrl,
                      decoration: _input("Телефон", Icons.phone),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: addressCtrl,
                      decoration: _input("Адрес", Icons.location_on),
                    ),
                    const SizedBox(height: 22),

                    const Text(
                      "Привязка карты",
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: cardNumberCtrl,
                      decoration:
                      _input("Номер карты", Icons.credit_card),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: cardHolderCtrl,
                      decoration: _input("Имя на карте", Icons.person),
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerFinal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE32227),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Создать аккаунт",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
