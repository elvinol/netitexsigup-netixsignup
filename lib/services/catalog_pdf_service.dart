import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class CatalogPdfService {
  // Format price to always show 2 decimals
  static String formatPrice(dynamic value) {
    if (value == null) return "-";
    try {
      return double.parse(value.toString()).toStringAsFixed(2);
    } catch (_) {
      return value.toString();
    }
  }

  static Future<void> generateFullCatalog({
    required String companyName,
    required Map<String, List<Map<String, dynamic>>> productsByCategory,
    required String logoPath,
    PdfColor brandColor = const PdfColor(0.1, 0.2, 0.6),
  }) async {
    final pdf = pw.Document();

    // Load logo
    final logoBytes = await rootBundle.load(logoPath);
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // CATEGORY IMAGE CACHE
    final Map<String, pw.MemoryImage?> categoryImages = {};

    // PRODUCT IMAGE CACHE
    final Map<String, pw.MemoryImage?> productImages = {};

    // 1️⃣ Preload category images
    for (final entry in productsByCategory.entries) {
      final categoryName = entry.key;
      final firstProduct = entry.value.isNotEmpty ? entry.value.first : null;

      if (firstProduct != null && firstProduct.containsKey('category_image_url')) {
        final url = firstProduct['category_image_url'];
        if (url != null && url.toString().isNotEmpty) {
          try {
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              categoryImages[categoryName] = pw.MemoryImage(response.bodyBytes);
            } else {
              categoryImages[categoryName] = null;
            }
          } catch (_) {
            categoryImages[categoryName] = null;
          }
        }
      }
    }

    // 2️⃣ Preload product images
    for (final entry in productsByCategory.entries) {
      for (final p in entry.value) {
        final url = (p['image_url'] ?? '').toString();

        if (url.isEmpty) {
          productImages[url] = null;
          continue;
        }

        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            productImages[url] = pw.MemoryImage(response.bodyBytes);
          } else {
            productImages[url] = null;
          }
        } catch (_) {
          productImages[url] = null;
        }
      }
    }

    // COVER PAGE
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildCoverPage(
          companyName: companyName,
          logo: logo,
          brandColor: brandColor,
        ),
      ),
    );

    // TABLE OF CONTENTS WITH CATEGORY IMAGES
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildTableOfContents(
          productsByCategory.keys.toList(),
          categoryImages,
          brandColor,
        ),
      ),
    );

    // CATEGORY PAGES
    for (final entry in productsByCategory.entries) {
      final categoryName = entry.key;
      final products = entry.value;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          footer: (context) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Page ${context.pageNumber}",
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          build: (context) => [
            _categoryHeader(categoryName, brandColor),
            pw.SizedBox(height: 12),
            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final p in products)
                  _productCard(
                    p,
                    productImages[(p['image_url'] ?? '').toString()],
                  ),
              ],
            ),
          ],
        ),
      );
    }

    // Output PDF
    final bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  // COVER PAGE
  static pw.Widget _buildCoverPage({
    required String companyName,
    required pw.ImageProvider logo,
    required PdfColor brandColor,
  }) {
    return pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Container(
            width: 140,
            height: 140,
            child: pw.Image(logo),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            companyName,
            style: pw.TextStyle(
              fontSize: 32,
              fontWeight: pw.FontWeight.bold,
              color: brandColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Product Catalogue",
            style: pw.TextStyle(
              fontSize: 20,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Generated on ${DateTime.now().toString().split(' ')[0]}",
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ⭐ TABLE OF CONTENTS WITH CATEGORY IMAGES
  static pw.Widget _buildTableOfContents(
    List<String> categories,
    Map<String, pw.MemoryImage?> categoryImages,
    PdfColor brandColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Table of Contents",
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: brandColor,
          ),
        ),
        pw.SizedBox(height: 20),

        ...categories.map(
          (c) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 40,
                  height: 40,
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(6),
                    color: PdfColors.grey300,
                  ),
                  child: categoryImages[c] != null
                      ? pw.ClipRRect(
                          horizontalRadius: 6,
                          verticalRadius: 6,
                          child: pw.Image(categoryImages[c]!, fit: pw.BoxFit.cover),
                        )
                      : pw.Center(
                          child: pw.Text(
                            "No\nImage",
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ),
                ),
                pw.SizedBox(width: 12),
                pw.Text(
                  c,
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // CATEGORY HEADER
  static pw.Widget _categoryHeader(String name, PdfColor brandColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          name,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: brandColor,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(),
      ],
    );
  }

  // PRODUCT CARD
  static pw.Widget _productCard(
    Map<String, dynamic> p,
    pw.MemoryImage? image,
  ) {
    final name = (p['name'] ?? '').toString();
    final code = (p['product_code'] ?? p['code'] ?? '').toString();
    final rawPrice = p['price'] ?? p['unit_price'];
    final price = formatPrice(rawPrice);
    final description = (p['description'] ?? '').toString();
    final sku = (p['sku'] ?? '').toString();
    final barcode = (p['barcode'] ?? '').toString();
    final stock = (p['stock'] ?? '').toString();

    return pw.Container(
      width: 180,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _productImage(image),
          pw.SizedBox(height: 8),
          pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text("Code: $code", style: const pw.TextStyle(fontSize: 10)),
          pw.Text("SKU: $sku", style: const pw.TextStyle(fontSize: 10)),
          pw.Text("Barcode: $barcode", style: const pw.TextStyle(fontSize: 10)),
          pw.Text("Stock: $stock", style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 4),
          pw.Text(
            description,
            maxLines: 3,
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "Price: $price",
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // PRODUCT IMAGE
  static pw.Widget _productImage(pw.MemoryImage? img) {
    if (img == null) {
      return pw.Container(
        height: 120,
        width: double.infinity,
        color: PdfColors.grey200,
        child: pw.Center(
          child: pw.Text(
            "No Image",
            style: pw.TextStyle(color: PdfColors.grey600),
          ),
        ),
      );
    }

    return pw.Container(
      height: 120,
      width: double.infinity,
      child: pw.Image(
        img,
        fit: pw.BoxFit.cover,
      ),
    );
  }
}
