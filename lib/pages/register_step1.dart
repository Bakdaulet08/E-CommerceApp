import 'package:flutter/material.dart';
import 'register_step2.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: _input("Имя", Icons.person),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: surnameCtrl,
                      decoration: _input("Фамилия", Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: emailCtrl,
                      decoration: _input("Email", Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: _input("Пароль", Icons.lock_outline),
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterStep2(
                                name: nameCtrl.text.trim(),
                                surname: surnameCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                                password: passwordCtrl.text.trim(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE32227),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Далее",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
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
