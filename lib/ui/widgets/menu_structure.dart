import 'package:fluentui_icons/fluentui_icons.dart';

class MenuItem {
  final String title;
  final String? routeName;
  final dynamic iconRegular;
  final dynamic iconFilled;
  final List<MenuItem> children;

  const MenuItem({
    required this.title,
    this.routeName,
    this.iconRegular,
    this.iconFilled,
    this.children = const [],
  });
}

// -------------------------------
// ICON HELPERS (24px)
// -------------------------------
dynamic iconR(dynamic icon) => icon;
dynamic iconF(dynamic icon) => icon;

// -------------------------------
// FULL MENU TREE
// -------------------------------
final List<MenuItem> appMenu = [

  // ---------------------------------------------------------
  // CATALOGUE
  // ---------------------------------------------------------
  MenuItem(
    title: "Catalogue",
    iconRegular: iconR(FluentIcons.box_24_regular),
    iconFilled: iconF(FluentIcons.box_24_filled),
    routeName: CatalogueScreen.routeName,
    children: [
      MenuItem(
        title: "Products",
        routeName: ProductsScreen.routeName,
      ),
      MenuItem(
        title: "Master products",
        routeName: MasterProductsScreen.routeName,
      ),
      MenuItem(
        title: "Categories",
        routeName: CategoriesScreen.routeName,
      ),
      MenuItem(
        title: "Brands",
        routeName: BrandsScreen.routeName,
      ),
      MenuItem(
        title: "Price lists",
        routeName: PriceListsScreen.routeName,
      ),
      MenuItem(
        title: "Stock levels",
        routeName: StockLevelsScreen.routeName,
      ),
    ],
  ),

  // ---------------------------------------------------------
  // CUSTOMERS
  // ---------------------------------------------------------
  MenuItem(
    title: "Customers",
    iconRegular: iconR(FluentIcons.people_24_regular),
    iconFilled: iconF(FluentIcons.people_24_filled),
    routeName: CustomersScreen.routeName,
    children: [
      MenuItem(
        title: "Customer list",
        routeName: CustomerListScreen.routeName,
      ),
      MenuItem(
        title: "Customer groups",
        routeName: CustomerGroupsScreen.routeName,
      ),
      MenuItem(
        title: "Customer types",
        routeName: CustomerTypesScreen.routeName,
      ),
    ],
  ),

  // ---------------------------------------------------------
  // QUICK ORDER
  // ---------------------------------------------------------
  MenuItem(
    title: "Quick order",
    iconRegular: iconR(FluentIcons.flash_24_regular),
    iconFilled: iconF(FluentIcons.flash_24_filled),
    routeName: QuickOrderScreen.routeName,
  ),

  // ---------------------------------------------------------
  // ORDERS
  // ---------------------------------------------------------
  MenuItem(
    title: "Orders",
    iconRegular: iconR(FluentIcons.receipt_24_regular),
    iconFilled: iconF(FluentIcons.receipt_24_filled),
    routeName: OrdersScreen.routeName,
    children: [
      MenuItem(
        title: "Order list",
        routeName: OrderListScreen.routeName,
      ),
      MenuItem(
        title: "Draft orders",
        routeName: DraftOrdersScreen.routeName,
      ),
      MenuItem(
        title: "Returns",
        routeName: ReturnsScreen.routeName,
      ),
    ],
  ),

  // ---------------------------------------------------------
  // REPORTS
  // ---------------------------------------------------------
  MenuItem(
    title: "Reports",
    iconRegular: iconR(FluentIcons.data_pie_24_regular),
    iconFilled: iconF(FluentIcons.data_pie_24_filled),
    routeName: ReportsScreen.routeName,
    children: [
      MenuItem(
        title: "Sales",
        children: [
          MenuItem(
            title: "Sales value",
            routeName: SalesValueReportScreen.routeName,
          ),
          MenuItem(
            title: "Sales quantity",
            routeName: SalesQuantityReportScreen.routeName,
          ),
          MenuItem(
            title: "Sales by customer",
            routeName: SalesByCustomerReportScreen.routeName,
          ),
          MenuItem(
            title: "Sales by product",
            routeName: SalesByProductReportScreen.routeName,
          ),
        ],
      ),
      MenuItem(
        title: "Products",
        children: [
          MenuItem(
            title: "Top products",
            routeName: TopProductsReportScreen.routeName,
          ),
          MenuItem(
            title: "Low stock",
            routeName: LowStockReportScreen.routeName,
          ),
        ],
      ),
      MenuItem(
        title: "Customers",
        children: [
          MenuItem(
            title: "Top customers",
            routeName: TopCustomersReportScreen.routeName,
          ),
          MenuItem(
            title: "Inactive customers",
            routeName: InactiveCustomersReportScreen.routeName,
          ),
        ],
      ),
      MenuItem(
        title: "Sales reps",
        children: [
          MenuItem(
            title: "Sales rep performance",
            routeName: SalesRepPerformanceReportScreen.routeName,
          ),
        ],
      ),
    ],
  ),

  // ---------------------------------------------------------
  // CHECK-INS
  // ---------------------------------------------------------
  MenuItem(
    title: "Check-ins",
    iconRegular: iconR(FluentIcons.location_24_regular),
    iconFilled: iconF(FluentIcons.location_24_filled),
    routeName: CheckinsScreen.routeName,
  ),

  // ---------------------------------------------------------
  // MANAGE YOUR DATA
  // ---------------------------------------------------------
  MenuItem(
    title: "Manage your data",
    iconRegular: iconR(FluentIcons.database_24_regular),
    iconFilled: iconF(FluentIcons.database_24_filled),
    routeName: ManageDataScreen.routeName,
  ),

  // ---------------------------------------------------------
  // IMPORT & EXPORT
  // ---------------------------------------------------------
  MenuItem(
    title: "Import & export data",
    iconRegular: iconR(FluentIcons.arrow_import_24_regular),
    iconFilled: iconF(FluentIcons.arrow_import_24_filled),
    routeName: ImportExportScreen.routeName,
    children: [
      MenuItem(
        title: "Import jobs",
        routeName: ImportJobsScreen.routeName,
      ),
      MenuItem(
        title: "Export data",
        routeName: ExportDataScreen.routeName,
      ),
    ],
  ),

  // ---------------------------------------------------------
  // SETTINGS
  // ---------------------------------------------------------
  MenuItem(
    title: "Settings",
    iconRegular: iconR(FluentIcons.settings_24_regular),
    iconFilled: iconF(FluentIcons.settings_24_filled),
    routeName: SettingsScreen.routeName,
  ),
];
