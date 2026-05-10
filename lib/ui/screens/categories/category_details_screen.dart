import 'package:flutter/material.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String categoryId;

  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category: $categoryId"),
      ),
      body: Center(
        child: Text(
          "Details for category: $categoryId",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
