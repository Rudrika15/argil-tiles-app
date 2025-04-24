import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:flutter/material.dart';
import '../model/common_product_model.dart';
import 'product_inquiry_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String url;
  final ProductModel? productModel;

  const ProductDetailsScreen({super.key, this.productModel, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3C8BA),
        title: Text(productModel?.names ?? ''),
        titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
      ),
       endDrawer: const SizedBox(
        width: 250,
        child: AppDrawer(),
      ),

      body: Column(
        children: [
          // Top Content - Scrollable
          Expanded(
            child: ListView(
              children: [
                _buildProductImage(),
                const SizedBox(height: 16),
                _buildSectionTitle("Product Information"),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: "Spaces",
                  rows: [
                    _infoRow(
                      "Primary Color",
                      productModel?.primarycolors ?? '',
                    ),
                    _infoRow("Stock", productModel?.status ?? ''),
                    _infoRow("Book Match", productModel?.bookmatch ?? ''),
                    _infoRow("Available Finish", "Polished"),
                  ],
                ),
                const SizedBox(height: 10),

                _buildInfoCard(
                  title: "Sizes",
                  rows: [
                    _infoRow("Thickness", productModel?.thicknesses ?? ''),
                    _infoRow("Slab Size", "1600 X 3200 MM"),
                  ],
                ),
                const SizedBox(height: 10),

                _buildApplicationsCard(),
              ],
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _actionButton(
                  context: context,
                  label: "Inquiry Now",
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductInquiryScreen(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== Widgets Below ==========

  Widget _buildProductImage() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Image.network(
          'https://admin.argiltiles.com/$url/${productModel?.mainImg}',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> rows}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("$label :")),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildApplicationsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Applications",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _applicationRow("Flooring", true, true),
            _applicationRow("Counters", true, true),
            _applicationRow("Wall", true, true),
            _applicationRow("Other", true, false),
          ],
        ),
      ),
    );
  }

  Widget _applicationRow(String label, bool residential, bool commercial) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text("$label :")),
          Expanded(
            child: Row(
              children: [
                const Text("Residential "),
                Icon(
                  residential ? Icons.check : Icons.close,
                  size: 16,
                  color: residential ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Text("Commercial "),
                Icon(
                  commercial ? Icons.check : Icons.close,
                  size: 16,
                  color: commercial ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
