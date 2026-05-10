import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'menu_structure.dart';

class SidebarMenu extends StatefulWidget {
  final bool isCollapsed;
  final bool isHidden;
  final Function(String routeName) onNavigate;

  const SidebarMenu({
    super.key,
    required this.isCollapsed,
    required this.isHidden,
    required this.onNavigate,
  });

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  String? activeRoute;
  final Map<String, bool> expanded = {};

  @override
  Widget build(BuildContext context) {
    if (widget.isHidden) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: widget.isCollapsed ? 70 : 260,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 12),
        children: [
          for (final item in appMenu) _buildMenuItem(item, level: 0),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, {required int level}) {
    final bool hasChildren = item.children.isNotEmpty;
    final bool isExpanded = expanded[item.title] ?? false;
    final bool isActive = activeRoute == item.routeName;

    final double indent = level * 16.0;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasChildren) {
              setState(() => expanded[item.title] = !isExpanded);
            } else if (item.routeName != null) {
              setState(() => activeRoute = item.routeName);
              widget.onNavigate(item.routeName!);
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(12 + indent, 10, 12, 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.blue.shade50 : Colors.transparent,
              border: isActive
                  ? Border(
                      left: BorderSide(
                        color: Colors.blue.shade600,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (item.iconRegular != null)
                  Icon(
                    isActive ? item.iconFilled : item.iconRegular,
                    size: 24,
                    color: isActive
                        ? Colors.blue.shade700
                        : Colors.grey.shade700,
                  ),

                if (!widget.isCollapsed)
                  const SizedBox(width: 12),

                if (!widget.isCollapsed)
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? Colors.blue.shade800
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),

                if (hasChildren && !widget.isCollapsed)
                  Icon(
                    isExpanded
                        ? FluentIcons.chevron_up_20_regular
                        : FluentIcons.chevron_down_20_regular,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
              ],
            ),
          ),
        ),

        if (hasChildren && isExpanded)
          Column(
            children: [
              for (final child in item.children)
                _buildMenuItem(child, level: level + 1),
            ],
          ),
      ],
    );
  }
}
