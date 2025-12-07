import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/my_drawer.dart';
import '../widgets/my_product_tile.dart';
import 'product_details_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String category = "all";
  String query = "";
  String sort = "none";

  final categories = ["all", "sport", "clothes", "tech", "food", "accessories"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final shop = context.read<ShopProvider>();
      final user = context.read<UserProvider>();

      shop.loadProducts();
      user.loadUser();
    });
  }



  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final products = shop.products;

    // фильтры
    final filtered = products.where((p) {
      final catOk = (category == "all" || p.category == category);
      final searchOk = p.name.toLowerCase().contains(query.toLowerCase());
      return catOk && searchOk;
    }).toList();

    // сортировка
    if (sort == "price_low") filtered.sort((a, b) => a.price.compareTo(b.price));
    if (sort == "price_high") filtered.sort((a, b) => b.price.compareTo(a.price));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kaspi Market", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, "/cartPage"),
          )
        ],
      ),
      drawer: const MyDrawer(),

      body: Column(
        children: [
          // 🔍 поиск
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: "Поиск...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                ),
              ),
            ),
          ),

          // 🔥 категории
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final selected = cat == category;
                return GestureDetector(
                  onTap: () => setState(() => category = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cat.toUpperCase(),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🔽 фильтры
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.filter_alt),
                onSelected: (val) => setState(() => sort = val),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: "price_low",
                    child: Text("Цена: низкая → высокая"),
                  ),
                  const PopupMenuItem(
                    value: "price_high",
                    child: Text("Цена: высокая → низкая"),
                  ),
                ],
              ),
            ],
          ),

          // 🛍 товары
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.66,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final product = filtered[i];
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
          )
        ],
      ),
    );
  }
}
