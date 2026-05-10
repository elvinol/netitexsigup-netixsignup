import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/main_layout.dart';
import '../widgets/global_product_card.dart';
import 'products_by_category_screen.dart';
import 'package:netitexsignup/services/catalog_pdf_service.dart';
import '../widgets/search_result_qty_selector.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ⭐ PRINT FULL CATALOG (ALL CATEGORIES)
  Future<void> _printFullCatalog() async {
    final supabase = Supabase.instance.client;

    // Fetch categories WITH image_url
    final categories = await supabase
        .from('categories')
        .select('id, name, image_url')
        .order('name');

    // Fetch products
    final products = await supabase
        .from('products')
        .select(
            'id, name, product_code, price, description, image_url, stock, sku, barcode, category_id')
        .order('name');

    // Grouping map
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final cat in categories) {
      grouped[cat['name']] = [];
    }

    for (final p in products) {
      final cat = categories.firstWhere(
        (c) => c['id'] == p['category_id'],
        orElse: () => {},
      );

      if (cat.isNotEmpty) {
        final productCopy = Map<String, dynamic>.from(p);

        // ⭐ Inject category image URL
        productCopy['category_image_url'] = cat['image_url'];

        grouped[cat['name']]!.add(productCopy);
      }
    }

    // Generate PDF
    await CatalogPdfService.generateFullCatalog(
      companyName: 'Netitex Sales',
      productsByCategory: grouped,
      logoPath: 'assets/logo.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    final Stream<List<Map<String, dynamic>>> activeStream = _searchQuery.isEmpty
        ? supabase
            .from('categories')
            .stream(primaryKey: ['id'])
            .order('name', ascending: true)
        : supabase
            .from('products')
            .stream(primaryKey: ['id'])
            .order('name', ascending: true);

    return MainLayout(
      title: 'Netitex',
      currentRoute: '/',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(),
          const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: activeStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final data = snapshot.data!.where((item) {
                  final name = (item['name'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                if (data.isEmpty) {
                  return const Center(child: Text("No items found."));
                }

                return _isGridView ? _buildGrid(data) : _buildList(data);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ⭐ HEADER BAR WITH PRINT ICON
  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.home, size: 18),
          const SizedBox(width: 8),
          Text(
            _searchQuery.isEmpty ? "Product catalogue" : "Search Results",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          const Spacer(),

          // SEARCH BAR
          Row(
            children: [
              Container(
                width: 350,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Find items...",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.cancel,
                                size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = "");
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF5C72C3),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                  ),
                ),
                child: const Icon(Icons.search, color: Colors.white, size: 18),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // ⭐ PRINT FULL CATALOG BUTTON
          Tooltip(
            message: "Print full catalog (PDF)",
            child: IconButton(
              icon: const Icon(Icons.print, size: 20),
              onPressed: _printFullCatalog,
            ),
          ),

          // GRID/LIST TOGGLE
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.72,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) => GlobalProductCard(
        item: data[index],
        isCategory: _searchQuery.isEmpty,
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        bool isFolder = _searchQuery.isEmpty;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Image.network(
              item['image_url'] ?? '',
              width: 50,
              fit: isFolder ? BoxFit.cover : BoxFit.contain,
            ),
            title: Text(
              item['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: isFolder
                ? const Text("Category Folder")
                : Text("XCD ${item['price'] ?? '0.00'}"),
            trailing: isFolder
                ? const Icon(Icons.chevron_right, color: Color(0xFF1A237E))
                : SizedBox(
                    width: 110,
                    child: SearchResultQtySelector(item: item),
                  ),
            onTap: () {
              if (isFolder) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsByCategoryScreen(
                      categoryId: item['id'].toString(),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
