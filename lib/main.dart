import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';


// providers
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/shop_provider.dart';

// repositories
import 'data/repositories/product_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/purchase_repository.dart';

// usecases
import 'domain/usecases/load_products.dart';
import 'domain/usecases/add_to_cart.dart';
import 'domain/usecases/remove_from_cart.dart';
import 'domain/usecases/process_purchase.dart';
import 'domain/usecases/load_history.dart';

// observer
import 'domain/observers/cart_observer.dart';

// pages
import 'presentation/pages/login_page.dart';
import 'presentation/pages/shop_page.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/balance_page.dart';
import 'presentation/pages/purchase_history_page.dart';
import 'presentation/pages/register_pages/register_step1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('kk_KZ', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // USER PROVIDER
        ChangeNotifierProvider(
          create: (_) {
            final user = UserProvider(); // <-- теперь без аргументов
            user.loadUser();
            return user;
          },
        ),

        // SHOP PROVIDER
        ChangeNotifierProvider(
          create: (_) {
            final productRepo = ProductRepository();
            final cartRepo = CartRepository();
            final userRepo = UserRepository();
            final purchaseRepo = PurchaseRepositoryImpl();

            final shop = ShopProvider(
              loadProductsUC: LoadProducts(productRepo),
              addToCartUC: AddToCart(cartRepo),
              removeFromCartUC: RemoveFromCart(cartRepo),
              processPurchaseUC: ProcessPurchase(
                purchaseRepo: purchaseRepo,
                userRepo: userRepo,
                cartRepo: cartRepo,
              ),
              loadHistoryUC: LoadHistory(purchaseRepo),
              observer: CartLoggerObserver(), // <-- теперь это конкретный класс
            );

            shop.loadProducts(); // загружаем товары
            return shop;
          },
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kaspi Market',
        home: const LoginPage(),

        routes: {
          '/loginPage': (_) => const LoginPage(),
          '/shopPage': (_) => const ShopPage(),
          '/cartPage': (_) => const CartPage(),
          '/balancePage': (_) => const BalancePage(),
          '/history': (_) => const PurchaseHistoryPage(),
          '/registerStep1': (_) => const RegisterStep1(),
        },
      ),
    );
  }
}
