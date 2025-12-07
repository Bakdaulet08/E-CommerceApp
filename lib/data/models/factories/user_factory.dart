// lib/data/models/factories/user_factory.dart
import '../user_profile.dart';

class UserFactory {
  static UserProfile fromMap(String uid, Map<String, dynamic>? data) {
    return UserProfile.fromMap(uid, data);
  }
}
