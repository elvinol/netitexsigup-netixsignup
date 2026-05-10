import 'package:flutter/material.dart';

class CustomersPagination extends StatelessWidget {
  final Color qGreyBorder;
  final int rowsPerPage;
  final int currentPage;
  final int total;
  final int start;
  final int end;
  final Function(int) onRowsPerPageChanged;
  final Function(int) onPageChanged;

  const CustomersPagination({
    super.key,
    required this.qGreyBorder,
    required this.rowsPerPage,
    required this.currentPage,
    required this.total,
    required this.start,
    required this.end,
    required this.onRowsPerPageChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: qGreyBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Records per page:", style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),

          DropdownButton<int>(
            value: rowsPerPage,
            underline: const SizedBox(),
            items: [10, 25, 50, 100]
                .map((v) => DropdownMenuItem(value: v, child: Text("$v")))
                .toList(),
            onChanged: (v) => onRowsPerPageChanged(v!),
          ),

          const SizedBox(width: 24),
          Text("${total == 0 ? 0 : start + 1}-$end of $total"),
          const SizedBox(width: 16),

          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 0
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),

          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: end < total
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
