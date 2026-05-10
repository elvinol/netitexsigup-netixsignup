import 'package:flutter/material.dart';
import 'app_sidebar.dart';

class MainLayout extends StatefulWidget {
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
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // ⭐ STATE: Tracks if the sidebar is expanded or collapsed
  bool _isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. THE TOP BAR (Always visible)
          Container(
            height: 56,
            color: const Color(0xFF1A237E), // Onsight Blue
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // ⭐ TOGGLE BUTTON: The Hamburger icon
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSidebarOpen = !_isSidebarOpen;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title, 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
                const Spacer(),
                const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                const SizedBox(width: 16),
              ],
            ),
          ),

          // 2. THE CONTENT AREA (Sidebar + Page)
          Expanded(
            child: Row(
              children: [
                // ⭐ ANIMATED SIDEBAR
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _isSidebarOpen ? 220 : 0, // Slides to 0 to hide
                  child: ClipRect( // Prevents sidebar content from bleeding out during animation
                    child: AppSidebar(currentRoute: widget.currentRoute),
                  ),
                ),

                // THE ACTUAL PAGE (Fills remaining space)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
