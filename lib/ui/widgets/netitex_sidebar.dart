import 'package:flutter/material.dart';

class NetitexSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(String) onItemSelected;

  const NetitexSidebar({
    super.key, 
    required this.currentRoute, 
    required this.onItemSelected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Column(
        children: [
          _buildBrand(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Section: Main Navigation
                _buildCompactRow(Icons.folder_open, "Catalogue", "categories"),
                _buildCompactRow(Icons.person_outline, "Customers", "customers"),
                _buildCompactRow(Icons.bolt, "Quick order", "quick_order"),
                _buildCompactRow(Icons.receipt_long, "Orders", "orders"),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Divider(height: 1, thickness: 0.5),
                ),
                
                // Section: Data & Management
                _buildCompactExpandable(Icons.bar_chart, "Reports"),
                _buildCompactExpandable(Icons.location_on_outlined, "Check-ins"),
                
                // ⭐ This links to your new ManageCategoriesScreen table
                _buildCompactRow(Icons.edit_outlined, "Manage Categories", "product_categories"),
                
                _buildCompactRow(Icons.cloud_upload_outlined, "Import & Export", "import_export"),
                _buildCompactExpandable(Icons.settings_outlined, "Settings"),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  /// Builds a clickable row with an icon and label. 
  /// Automatically highlights if it matches the current route.
  Widget _buildCompactRow(IconData icon, String label, String route) {
    bool isSelected = currentRoute == route;
    return InkWell(
      onTap: () => onItemSelected(route),
      child: Container(
        height: 32, // Slightly increased height for better click targets
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: isSelected ? const Color(0xFFF0F2FF) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon, 
              size: 16, 
              color: isSelected ? const Color(0xFF1A237E) : Colors.black87
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an expandable-style row for sections that might have sub-menus later.
  Widget _buildCompactExpandable(IconData icon, String label) {
    String route = label.toLowerCase().replaceAll(' ', '_');
    bool isSelected = currentRoute == route;

    return SizedBox(
      height: 32,
      child: InkWell(
        onTap: () => onItemSelected(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        "NETITEX", 
        style: TextStyle(
          fontWeight: FontWeight.w900, 
          fontSize: 18, 
          color: Color(0xFF1A237E),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "NETITEXSALES V1.0",
        style: TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold, 
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}