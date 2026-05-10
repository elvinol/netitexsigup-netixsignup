import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ADD THIS: This fixes the 'productsByCategoryProvider' error
final productsByCategoryProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, categoryId) async {
  final supabase = Supabase.instance.client;
  
  // 1. Get product IDs from the junction table
  final linkResponse = await supabase
      .from('product_categories')
      .select('product_id')
      .eq('category_id', categoryId);

  final List<String> ids = (linkResponse as List).map((row) => row['product_id'] as String).toList();

  if (ids.isEmpty) return [];

  // 2. Get the actual products
  final prodResponse = await supabase
      .from('products')
      .select()
      .inFilter('id', ids);

  return List<Map<String, dynamic>>.from(prodResponse);
});

class ProductsScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const ProductsScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calling the provider we just defined above
    final productsAsync = ref.watch(productsByCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(products[index]['name'] ?? 'Product'),
            subtitle: Text('\$${products[index]['price'] ?? '0.00'}'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}