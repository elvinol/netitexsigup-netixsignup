import 'package:flutter/material.dart';
import 'app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String currentRoute;

  const MainLayout({
    super.key, 
    required this.child, 
    required this.title, 
    required this.currentRoute
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(currentRoute: currentRoute),
          Expanded(
            child: Column(
              children: [
                // THE TOP BAR
                Container(
                  height: 56,
                  color: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                    ],
                  ),
                ),
                // THE ACTUAL PAGE CONTENT
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
