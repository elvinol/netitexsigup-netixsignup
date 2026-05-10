import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:netitexsignup/ui/screens/customers/customers_pagination.dart';

class CustomersTable extends StatelessWidget {
  final Color qGreyBorder;
  final Color qPrimary;
  final String searchQuery;
  final int rowsPerPage;
  final int currentPage;
  final Function(int) onRowsPerPageChanged;
  final Function(int) onPageChanged;

  const CustomersTable({
    super.key,
    required this.qGreyBorder,
    required this.qPrimary,
    required this.searchQuery,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onRowsPerPageChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('customers').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        final allData = snapshot.data ?? [];

        // Sort A–Z
        allData.sort((a, b) {
          final nameA = (a['company_name'] ?? '').toString().toLowerCase();
          final nameB = (b['company_name'] ?? '').toString().toLowerCase();
          return nameA.compareTo(nameB);
        });

        // Filter
        final filtered = allData.where((c) {
          final name = (c['company_name'] ?? '').toString().toLowerCase();
          final code = (c['customer_code'] ?? '').toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) ||
              code.contains(searchQuery.toLowerCase());
        }).toList();

        final total = filtered.length;
        final start = currentPage * rowsPerPage;
        final pageData = filtered.skip(start).take(rowsPerPage).toList();
        final end = (start + pageData.length).clamp(0, total);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 48,
                    dataRowHeight: 52,
                    columnSpacing: 50,
                    columns: const [
                      DataColumn(label: Icon(Icons.check_box_outline_blank)),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Name ↑')),
                      DataColumn(label: Text('Code')),
                      DataColumn(label: Text('Primary contact')),
                      DataColumn(label: Text('Sales rep')),
                    ],
                    rows: pageData.isEmpty
                        ? [
                            const DataRow(cells: [
                              DataCell(SizedBox()),
                              DataCell(SizedBox()),
                              DataCell(Text("No results found")),
                              DataCell(SizedBox()),
                              DataCell(SizedBox()),
                              DataCell(SizedBox()),
                            ])
                          ]
                        : pageData.map((c) {
                            return DataRow(cells: [
                              const DataCell(
                                Icon(Icons.check_box_outline_blank),
                              ),
                              const DataCell(
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color(0xFFF5F5F5),
                                  child: Icon(Icons.person, size: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  c['company_name'] ?? '-',
                                  style: TextStyle(
                                    color: qPrimary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              DataCell(Text(c['customer_code'] ?? '-')),
                              DataCell(Text(c['primary_contact_name'] ?? '-')),
                              DataCell(Text(c['allocated_to'] ?? 'unassigned')),
                            ]);
                          }).toList(),
                  ),
                ),
              ),
            ),

            // Pagination
            CustomersPagination(
              qGreyBorder: qGreyBorder,
              rowsPerPage: rowsPerPage,
              currentPage: currentPage,
              total: total,
              start: start,
              end: end,
              onRowsPerPageChanged: onRowsPerPageChanged,
              onPageChanged: onPageChanged,
            ),
          ],
        );
      },
    );
  }
}
