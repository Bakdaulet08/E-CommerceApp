import 'package:flutter/material.dart';
import 'register_step2.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final name = TextEditingController();
  final surname = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                child: Column(children: [
                  _field(name, "Имя", Icons.person),
                  _field(surname, "Фамилия", Icons.person_outlined),
                  _field(email, "Email", Icons.email),
                  _field(pass, "Пароль", Icons.lock, obscure: true),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: _btn(),
                      child: const Text("Далее", style: TextStyle(color: Colors.white, fontSize: 20)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterStep2(
                              name: name.text.trim(),
                              surname: surname.text.trim(),
                              email: email.text.trim(),
                              password: pass.text.trim(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String l, IconData i,
      {bool obscure = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: c,
          obscureText: obscure,
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
