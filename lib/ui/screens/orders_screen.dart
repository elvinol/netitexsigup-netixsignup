import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/main_layout.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Color qPrimary = const Color(0xFF1976D2);
  final Color qGreyBorder = const Color(0xFFE0E0E0);
  final Color qBackground = const Color(0xFFF5F5F5);

  final TextEditingController _searchController = TextEditingController();
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Orders',
      currentRoute: '/orders',
      child: Container(
        color: qBackground,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(),
            _buildFilterBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: qGreyBorder),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _buildOrderDataStream(),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Orders", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: qPrimary, elevation: 0),
            child: const Text("CREATE ORDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        children: [
          Row(
            children: [
              _filterInput("Search by order # or customer", 2),
              const SizedBox(width: 12),
              _filterDropdown("Filter by status"),
              const SizedBox(width: 12),
              _filterDropdown("Filter by sales rep"),
              const SizedBox(width: 12),
              _filterDropdown("Filter by date"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() { _searchController.clear(); }),
                child: Text("RESET", style: TextStyle(color: qPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5C72C3), elevation: 0),
                child: const Text("SEARCH", style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDataStream() {
    final supabase = Supabase.instance.client;
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('orders').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final total = data.length;
        final start = (_currentPage * _rowsPerPage);
        final pageData = data.skip(start).take(_rowsPerPage).toList();
        final rangeEnd = (start + pageData.length).clamp(0, total);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 48,
                  columnSpacing: 60,
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
                  columns: const [
                    DataColumn(label: Icon(Icons.check_box_outline_blank, size: 18, color: Colors.grey)),
                    DataColumn(label: Text('Order #')),
                    DataColumn(label: Text('Date ↑')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Items')),
                  ],
                  rows: pageData.isEmpty 
                      ? [const DataRow(cells: [
                          DataCell(SizedBox()), DataCell(SizedBox()),
                          DataCell(Text("No orders found", style: TextStyle(color: Colors.grey))),
                          DataCell(SizedBox()), DataCell(SizedBox()), DataCell(SizedBox()), DataCell(SizedBox()),
                        ])]
                      : pageData.map((order) => DataRow(cells: [
                          const DataCell(Icon(Icons.check_box_outline_blank, size: 18, color: Colors.grey)),
                          DataCell(Text(order['order_number'] ?? '-', style: TextStyle(color: qPrimary, fontWeight: FontWeight.bold))),
                          DataCell(Text(order['created_at']?.split('T')[0] ?? '-')),
                          DataCell(Text(order['customer_name'] ?? '-')),
                          DataCell(Text("XCD ${order['total_amount'] ?? '0.00'}")),
                          DataCell(Text(order['status'] ?? 'Pending')),
                          const DataCell(Text('View details', style: TextStyle(color: Color(0xFF1976D2), fontSize: 12))),
                        ])).toList(),
                ),
              ),
            ),
            _buildPaginationBar(start + 1, rangeEnd, total),
          ],
        );
      },
    );
  }

  Widget _buildPaginationBar(int start, int end, int total) {
    return Container(
      height: 48,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: qGreyBorder))),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Records per page:", style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _rowsPerPage,
            underline: const SizedBox(),
            items: [10, 25, 50, 100].map((int value) => DropdownMenuItem(
              value: value, 
              child: Text("$value", style: const TextStyle(fontSize: 12))
            )).toList(),
            onChanged: (val) => setState(() { _rowsPerPage = val!; _currentPage = 0; }),
          ),
          const SizedBox(width: 24),
          Text("${total == 0 ? 0 : start}-$end of $total", style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null),
          IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: end < total ? () => setState(() => _currentPage++) : null),
        ],
      ),
    );
  }

  Widget _filterInput(String hint, int flex) => Expanded(flex: flex, child: Container(height: 38, decoration: BoxDecoration(border: Border.all(color: qGreyBorder), color: Colors.white), child: TextField(style: const TextStyle(fontSize: 12), decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.only(left: 10, bottom: 12)))));
  Widget _filterDropdown(String hint) => Expanded(child: Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(border: Border.all(color: qGreyBorder), color: Colors.white), child: DropdownButtonHideUnderline(child: DropdownButton<String>(hint: Text(hint, style: const TextStyle(fontSize: 11)), items: const [], onChanged: (v) {}))));
}
