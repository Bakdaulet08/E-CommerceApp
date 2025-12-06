class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  // Конструктор из Firestore
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      name: data["name"],
      price: (data["price"] as num).toDouble(),
      description: data["description"],
      imageUrl: data["imageUrl"],
      category: data["category"],
    );
  }

}
