// lib/data/models/product.dart
class Product {
  final String id; // id документа (если есть)
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  // Конструктор из Map (Firestore)
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: (data['__id'] ?? data['id'] ?? '') as String,
      name: (data['name'] ?? '') as String,
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : double.tryParse('${data['price']}') ?? 0.0,
      description: (data['description'] ?? '') as String,
      imageUrl: (data['imageUrl'] ?? data['imagePath'] ?? '') as String,
      category: (data['category'] ?? 'uncategorized') as String,
    );
  }

  // В Map для записи в Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}
