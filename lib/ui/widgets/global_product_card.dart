import 'package:flutter/material.dart';
import '../screens/products_by_category_screen.dart';

class GlobalProductCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isCategory;

  const GlobalProductCard({
    super.key, 
    required this.item, 
    required this.isCategory
  });

  @override
  State<GlobalProductCard> createState() => _GlobalProductCardState();
}

class _GlobalProductCardState extends State<GlobalProductCard> {
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isCategory) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsByCategoryScreen(
                categoryId: widget.item['id'].toString(),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            // 1. IMAGE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.network(
                  widget.item['image_url'] ?? 'https://placeholder.com',
                  fit: widget.isCategory ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            ),
            // 2. NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.item['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // 3. PRICE
            Text(
              widget.isCategory ? "" : 'XCG ${widget.item['price'] ?? "0.00"}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 8),
            // 4. QTY BUTTONS
            if (!widget.isCategory)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _btn(Icons.remove, () => setState(() => _qty > 0 ? _qty-- : null)),
                  Container(
                    width: 32, 
                    alignment: Alignment.center, 
                    child: Text('$_qty', style: const TextStyle(fontSize: 13))
                  ),
                  _btn(Icons.add, () => setState(() => _qty++)),
                ],
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback tap) => InkWell(
    onTap: tap,
    child: Container(
      width: 30, 
      height: 26,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E), 
        borderRadius: BorderRadius.all(Radius.circular(2))
      ),
      child: Icon(icon, color: Colors.white, size: 14),
    ),
  );
}
