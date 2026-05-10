import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:netitexsignup/ui/widgets/global_product_card.dart';
import 'package:netitexsignup/services/catalog_pdf_service.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final String categoryId;

  const ProductsByCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 5 : (screenWidth > 600 ? 3 : 2);

    return FutureBuilder<List<dynamic>>(
      future: supabase
          .from('products')
          .select('*, categories!fk_category(name)')
          .eq('category_id', categoryId)
          .order('name', ascending: true),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];
        String categoryName = 'Product catalogue';

        if (products.isNotEmpty) {
          final firstProduct = products.first;
          categoryName =
              firstProduct['categories']?['name'] ?? 'Product catalogue';
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black87),
            title: Row(
              children: [
                Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),

                // ⭐ PRINT BUTTON (ONSIGHT STYLE)
                Tooltip(
                  message: 'Print this category (PDF)',
                  child: IconButton(
                    icon: Icon(
                      Icons.print,
                      size: 20,
                      color: products.isEmpty
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                    onPressed: products.isEmpty
                        ? null
                        : () async {
                            // Build a single-category map for the PDF engine
                            final map = <String, List<Map<String, dynamic>>>{
                              categoryName: products
                                  .cast<Map<String, dynamic>>()
                                  .toList(),
                            };

                            await CatalogPdfService.generateFullCatalog(
                              companyName: 'Netitex Sales',
                              productsByCategory: map,
                              logoPath: 'assets/logo.png',
                            );
                          },
                  ),
                ),
              ],
            ),
          ),
          body: _buildBody(context, snapshot, crossAxisCount),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot snapshot, int crossAxisCount) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final products = snapshot.data as List<dynamic>? ?? [];

    if (products.isEmpty) {
      return const Center(child: Text('No products found in this category.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GlobalProductCard(
          item: products[index],
          isCategory: false,
        );
      },
    );
  }
}
