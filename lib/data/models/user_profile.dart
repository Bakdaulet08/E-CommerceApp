// lib/data/models/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String address;
  final int balance;
  final DateTime? createdAt;
  final Map<String, dynamic>? card; // { number, holder } — хранить осторожно!

  UserProfile({
    required this.uid,
    required this.email,
    this.name = '',
    this.surname = '',
    this.phone = '',
    this.address = '',
    this.balance = 0,
    this.createdAt,
    this.card,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic>? data) {
    if (data == null) {
      return UserProfile(uid: uid, email: '', balance: 0);
    }

    final ts = data['createdAt'];
    DateTime? created;
    if (ts is Timestamp) {
      created = ts.toDate();
    } else if (ts is DateTime) {
      created = ts;
    }

    return UserProfile(
      uid: uid,
      email: (data['email'] ?? '') as String,
      name: (data['name'] ?? '') as String,
      surname: (data['surname'] ?? '') as String,
      phone: (data['phone'] ?? '') as String,
      address: (data['address'] ?? '') as String,
      balance: (data['balance'] is num) ? (data['balance'] as num).toInt() : int.tryParse('${data['balance']}') ?? 0,
      createdAt: created,
      card: (data['card'] is Map) ? Map<String, dynamic>.from(data['card']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'address': address,
      'balance': balance,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'card': card ?? {},
    };
  }

// Полезный метод для обновления баланса атомарно использовать Firestore FieldValue.increment
}
