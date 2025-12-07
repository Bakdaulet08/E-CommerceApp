// lib/data/datasources/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// FirestoreAdapter / Service — маленький адаптер вокруг
/// FirebaseFirestore. Он предоставляет четкие методы, которые
/// репозитории / usecases / providers будут вызывать.
/// Это реализует Adapter pattern и скрывает детали Firestore.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? instance})
      : _db = instance ?? FirebaseFirestore.instance;

  /// Получить все документы коллекции в виде списка Map
  Future<List<Map<String, dynamic>>> fetchCollection(String collectionPath) async {
    final snap = await _db.collection(collectionPath).get();
    return snap.docs.map((d) {
      final data = d.data();
      // добавляем ID документа — иногда полезно
      data['__id'] = d.id;
      return data;
    }).toList();
  }

  /// Получить один документ по path "collection/docId"
  Future<Map<String, dynamic>?> fetchDocument(String collectionPath, String docId) async {
    final doc = await _db.collection(collectionPath).doc(docId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    data['__id'] = doc.id;
    return data;
  }

  /// Добавить документ (auto-id) в коллекцию и вернуть id
  Future<String> addDocument(String collectionPath, Map<String, dynamic> data) async {
    final ref = await _db.collection(collectionPath).add(data);
    return ref.id;
  }

  /// Установить документ по id (перезаписать/создать)
  Future<void> setDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).doc(docId).set(data, SetOptions(merge: true));
  }

  /// Обновить документ полями
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).doc(docId).update(data);
  }

  /// Удалить документ
  Future<void> deleteDocument(String collectionPath, String docId) async {
    await _db.collection(collectionPath).doc(docId).delete();
  }

  /// Получить поток (stream) коллекции — полезно для real-time UI
  Stream<List<Map<String, dynamic>>> collectionStream(String collectionPath,
      {List<QueryFunction<Map<String, dynamic>>>? queryModifiers}) {
    Query<Map<String, dynamic>> query = _db.collection(collectionPath).withConverter(
      fromFirestore: (snap, _) => snap.data()!..putIfAbsent('__id', () => snap.id),
      toFirestore: (map, _) => map,
    );

    // Apply modifiers if provided (not required)
    if (queryModifiers != null) {
      for (final mod in queryModifiers) {
        // modifiers are not used here because of strong typing; this is placeholder
        // In higher-level code you can build queries directly via firestore_service or create overloads.
      }
    }

    // Return stream of simple maps
    return _db.collection(collectionPath).snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        if (data is Map<String, dynamic>) {
          data['__id'] = d.id;
          return data;
        } else {
          return <String, dynamic>{'__id': d.id};
        }
      }).toList();
    });
  }

  /// Утилитный метод: транзакция для списания/пополнения баланса
  Future<void> runTransaction(Function(Transaction tx, DocumentReference userRef) transactionBody, String usersDocId) async {
    final userRef = _db.collection('users').doc(usersDocId);
    await _db.runTransaction((tx) async {
      await transactionBody(tx, userRef);
    });
  }
}

/// Тип-алиас для возможных query модификаторов (пока заглушка)
typedef QueryFunction<T> = Query<T> Function(Query<T> query);
