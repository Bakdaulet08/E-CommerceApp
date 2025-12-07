import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'register_pages/register_step1.dart';
import 'shop_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();

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
                child: Column(children: [
                  TextField(
                    controller: email,
                    decoration: _input("Email", Icons.email),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pass,
                    obscureText: true,
                    decoration: _input("Пароль", Icons.lock),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: _btn(),
                      child: const Text("Войти",
                          style: TextStyle(fontSize: 18, color: Colors.white),),
                      onPressed: () async {
                        final ok = await user.login(
                          email.text.trim(),
                          pass.text.trim(),
                          context,
                        );
                        if (ok) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ShopPage()));
                        }
                      },
                    ),
                  )
                ]),
              ),

              const SizedBox(height: 16),
              GestureDetector(
                child: const Text(
                  "Создать аккаунт",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterStep1()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none),
  );

  ButtonStyle _btn() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFE32227),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
