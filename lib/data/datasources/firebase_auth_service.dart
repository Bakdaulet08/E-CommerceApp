// lib/data/datasources/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

/// Адаптер для FirebaseAuth.
/// Инкапсулирует логику регистрации / логина / получения текущего юзера.
/// Это упрощает тестирование и делает код зависимым от абстракций.
class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService({FirebaseAuth? instance}) : _auth = instance ?? FirebaseAuth.instance;

  /// Регистрация: возвращает UserCredential
  Future<UserCredential> registerWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  /// Логин по email/password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  /// Выход
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Текущий пользователь
  User? get currentUser => _auth.currentUser;

  /// Stream состояния авторизации (удобно подписываться в UI)
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
