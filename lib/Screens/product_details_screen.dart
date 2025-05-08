import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/inquiry_form.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../model/common_product_model.dart';

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
      ),
      endDrawer: DrawerWidget(),

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
                  iconPath: "assets/images/spaces_icon.png",
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
                  iconPath: "assets/images/sizes_icon.png",
                  title: "Sizes",
                  rows: [
                    _infoRow("Thickness", productModel?.thicknesses ?? ''),
                    _infoRow("Slab Size", "1600 X 3200 MM"),
                  ],
                ),
                const SizedBox(height: 10),

                _buildApplicationsCard(
                  iconPath: "assets/images/application_icon.png",
                ),
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
                      () => showDialog(
                        context: context,
                        builder:
                            (context) => Dialog(
                              child: InquiryForm(
                                productName: productModel?.names ?? "Not Found",
                                category: url,
                              ),
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
    return CustomContainer(
      borderColor: AppColors.greyColor,
      borderWidth: 0.4,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      padding: EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(AppSize.size10),
      backGroundColor: AppColors.whiteColor,
      height: 20.h,
      child:
          productModel?.availableImages.isNotEmpty == true
              ? PageView.builder(
                itemCount: productModel?.availableImages.length ?? 0,
                itemBuilder:
                    (context, index) => CustomContainer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: Image.network(
                          'https://admin.argiltiles.com/$url/${productModel?.getImageByIndex(index: index)}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
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

  Widget _buildInfoCard({
    required String title,
    required List<Widget> rows,
    required String iconPath,
  }) {
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
            Row(
              children: [
                iconImageContainer(iconPath),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...rows,
          ],
        ),
      ),
    );
  }

  CustomContainer iconImageContainer(String iconPath) {
    return CustomContainer(
      margin: EdgeInsets.only(right: 3.w),
      height: AppSize.size20,
      width: AppSize.size20,
      image: DecorationImage(image: AssetImage(iconPath)),
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

  Widget _buildApplicationsCard({required String iconPath}) {
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
            Row(
              children: [
                iconImageContainer(iconPath),
                const Text(
                  "Applications",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
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
