import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/categories_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(
            child: Text(
              "No categories found",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        // ⭐ Responsive column count
        final width = MediaQuery.of(context).size.width;
        int crossAxisCount = 2;
        if (width > 1400) crossAxisCount = 4;
        else if (width > 1100) crossAxisCount = 3;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.8, // ⭐ Smaller, wider blocks
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final c = categories[i];

            return _CategoryTile(
              name: c['name'],
              imageUrl: c['image_url'],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/products-by-category',
                  arguments: c['id'],
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          "Error loading categories: $e",
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _hover ? Colors.black26 : Colors.black12,
                blurRadius: _hover ? 12 : 6,
                offset: const Offset(0, 3),
              )
            ],
            border: Border.all(
              color: _hover ? Colors.blue.shade200 : Colors.transparent,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ⭐ Smaller image
              if (widget.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl!,
                    height: 55,
                    width: 55,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.folder,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(width: 20),

              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
