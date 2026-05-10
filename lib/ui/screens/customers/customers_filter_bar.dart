import 'package:flutter/material.dart';

class CustomersFilterBar extends StatelessWidget {
  final Color qPrimary;
  final Color qGreyBorder;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onReset;

  const CustomersFilterBar({
    super.key,
    required this.qPrimary,
    required this.qGreyBorder,
    required this.searchController,
    required this.onSearchChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        children: [
          Row(
            children: [
              _filterInput("Search by name or code", 2),
              const SizedBox(width: 8),
              _filterDropdown("Filter by customer group"),
              const SizedBox(width: 8),
              _filterDropdown("Filter by sales rep"),
              const SizedBox(width: 8),
              _filterDropdown("Filter by status"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onReset,
                child: Text(
                  "RESET",
                  style: TextStyle(color: qPrimary, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C72C3),
                ),
                child: const Text(
                  "SEARCH",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterInput(String hint, int flex) => Expanded(
        flex: flex,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: qGreyBorder),
            color: Colors.white,
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10, bottom: 12),
            ),
          ),
        ),
      );

  Widget _filterDropdown(String hint) => Expanded(
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: qGreyBorder),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                hint,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              items: const [],
              onChanged: (v) {},
            ),
          ),
        ),
      );
}
