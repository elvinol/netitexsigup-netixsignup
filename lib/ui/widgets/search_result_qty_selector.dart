import 'package:flutter/material.dart';

class SearchResultQtySelector extends StatefulWidget {
  final Map<String, dynamic> item;
  const SearchResultQtySelector({super.key, required this.item});

  @override
  State<SearchResultQtySelector> createState() =>
      _SearchResultQtySelectorState();
}

class _SearchResultQtySelectorState extends State<SearchResultQtySelector> {
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _btn(Icons.remove, () => setState(() => _qty > 0 ? _qty-- : null)),
        Container(
          width: 30,
          alignment: Alignment.center,
          child: Text(
            "$_qty",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _btn(Icons.add, () => setState(() => _qty++)),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
