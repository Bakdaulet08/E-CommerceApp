import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../shop_page.dart';

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
  final phone = TextEditingController();
  final address = TextEditingController();
  final cardNum = TextEditingController();
  final holder = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE32227),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
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
                    _f(phone, "Телефон", Icons.phone),
                    _f(address, "Адрес", Icons.location_on),
                    const SizedBox(height: 20),
                    const Text("Привязка карты",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    _f(cardNum, "Номер карты", Icons.credit_card),
                    _f(holder, "Владелец карты", Icons.person),

                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: _btn(),
                        child: const Text("Создать аккаунт", style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () async {
                          final ok = await user.register(
                            name: widget.name,
                            surname: widget.surname,
                            email: widget.email,
                            password: widget.password,
                            phone: phone.text.trim(),
                            address: address.text.trim(),
                            cardNumber: cardNum.text.trim(),
                            cardHolder: holder.text.trim(),
                            context: context,
                          );

                          if (ok) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShopPage(),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _f(TextEditingController c, String l, IconData i) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: l,
        prefixIcon: Icon(i),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    ),
  );

  ButtonStyle _btn() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFE32227),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
