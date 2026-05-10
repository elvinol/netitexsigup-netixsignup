import 'package:flutter/material.dart';
import 'package:netitexsignup/ui/screens/customers/customers_header.dart';
import 'package:netitexsignup/ui/screens/customers/customers_filter_bar.dart';
import 'package:netitexsignup/ui/screens/customers/customers_table.dart';
import 'package:netitexsignup/ui/widgets/main_layout.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final Color qPrimary = const Color(0xFF1976D2);
  final Color qGreyBorder = const Color(0xFFE0E0E0);
  final Color qBackground = const Color(0xFFF5F5F5);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Customers",
      currentRoute: "/customers",
      child: Container(
        color: qBackground,
        child: Column(
          children: [
            CustomersHeader(qPrimary: qPrimary),
            CustomersFilterBar(
              qPrimary: qPrimary,
              qGreyBorder: qGreyBorder,
              searchController: _searchController,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              onReset: () => setState(() {
                _searchController.clear();
                _searchQuery = "";
              }),
            ),
            Expanded(
              child: CustomersTable(
                qGreyBorder: qGreyBorder,
                qPrimary: qPrimary,
                searchQuery: _searchQuery,
                rowsPerPage: _rowsPerPage,
                currentPage: _currentPage,
                onRowsPerPageChanged: (v) =>
                    setState(() => {_rowsPerPage = v, _currentPage = 0}),
                onPageChanged: (v) => setState(() => _currentPage = v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
