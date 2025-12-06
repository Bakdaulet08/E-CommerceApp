import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';
import '../models/shop.dart';
import '../components/my_product_tile.dart';
import 'product_details_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String selectedCategory = "all";
  String searchQuery = "";
  String sortType = "none";

  final categories = [
    "all",
    "sport",
    "clothes",
    "tech",
    "food",
    "accessories",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<Shop>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>().shop;

    // 🔎 Фильтрация по категории
    final filtered = shop.where((product) {
      final matchesCategory =
          selectedCategory == "all" || product.category == selectedCategory;

      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    // ↕ Сортировка
    if (sortType == "price_low") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortType == "price_high") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        title: const Text(
          "Kaspi Market",
          style: TextStyle(color: Colors.black),
        ),

        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cartPage'),
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
        ],
      ),
      drawer: const MyDrawer(),


      body: Column(
        children: [
          // 🔍 ПОИСК
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Поиск товаров...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),

          // 🔥 КАТЕГОРИИ
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;

                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cat.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔽 ФИЛЬТРЫ
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.filter_alt),
                onSelected: (value) {
                  setState(() => sortType = value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "price_low",
                    child: Text("Цена: дешевые → дорогие"),
                  ),
                  const PopupMenuItem(
                    value: "price_high",
                    child: Text("Цена: дорогие → дешевые"),
                  ),
                ],
              ),
            ],
          ),

          // 🛍 СЕТКА ТОВАРОВ
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("Нет товаров"))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // << KASPI STYLE
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(product),
                      ),
                    );
                  },
                  child: MyProductTile(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
