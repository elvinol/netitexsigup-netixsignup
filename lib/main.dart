import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase_config.dart';

// ⭐ Absolute imports so nothing breaks when moving files
import 'package:netitexsignup/ui/screens/dashboard_screen.dart';
import 'package:netitexsignup/ui/screens/customers/customers_screen.dart';
import 'package:netitexsignup/ui/screens/orders_screen.dart';
import 'package:netitexsignup/ui/screens/products_by_category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netitex Sales',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1A237E),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            );

          case '/customers':
            // ⭐ Must NOT be const anymore
            return MaterialPageRoute(
              builder: (_) => CustomersScreen(),
            );

          case '/orders':
            return MaterialPageRoute(
              builder: (_) => OrdersScreen(),
            );

          case '/products-by-category':
            // ⭐ categoryId is dynamic → cannot use const
            final categoryId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) =>
                  ProductsByCategoryScreen(categoryId: categoryId),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            );
        }
      },
    );
  }
}
