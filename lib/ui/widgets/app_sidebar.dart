import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  const AppSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column( // Using Column instead of ListView to keep 'NETITEXz' at the bottom
          children: [
            const SizedBox(height: 20),
            
            // ⭐ Catalogue: Now a simple clickable item with no sub-menu
            _simpleItem(context, Icons.folder, 'Catalogue', '/'),

            _simpleItem(context, Icons.person, 'Customers', '/customers'),
            
            _simpleItem(context, Icons.description, 'Orders', '/orders'),

            const Spacer(), // Pushes the following widgets to the bottom
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'NETITEX', 
                style: TextStyle(letterSpacing: 3, color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ⭐ New Helper: Creates a standard, non-expandable Sidebar Item
  Widget _simpleItem(BuildContext context, IconData icon, String label, String route) {
    bool isSelected = currentRoute == route;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      leading: Icon(
        icon, 
        size: 20, 
        color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
      ),
      title: Text(
        label, 
        style: TextStyle(
          fontSize: 13, 
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
        ),
      ),
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
