import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/product_inquiry_provider.dart';
import 'package:argil_tiles/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'custom_container.dart';

class InquiryForm extends StatelessWidget {
  InquiryForm({
    super.key,
    required this.productName,
    required this.category,
    required this.productId,
  });
  final String productName;
  final int productId;
  final String category;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ProductInquiryProvider inquiryProvider =
        context.watch<ProductInquiryProvider>();
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return CustomContainer(
      width: isTablet ? 520.0 : 80.w,
      padding: EdgeInsets.all(isTablet ? 20.0 : AppSize.size10),
      backGroundColor: const Color(0xFFF9F4EF),
      borderRadius: BorderRadius.circular(AppSize.size10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, size: isTablet ? 28 : 24),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Product Inquiry",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 22 : 18,
              ),
            ),
            Text(
              "Please let us know if you have any questions.",
              style: TextStyle(fontSize: isTablet ? 14 : 12),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: inquiryProvider.nameController,
                    onChanged: (value) => formKey.currentState?.validate(),
                    hintText: "Name",
                    validator: (value) => value!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: inquiryProvider.emailController,
                    onChanged: (value) => formKey.currentState?.validate(),
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email";
                      }
                      final emailRegex = RegExp(
                        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                      );
                      return emailRegex.hasMatch(value)
                          ? null
                          : "Enter valid email";
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: inquiryProvider.contactController,
                    onChanged: (value) => formKey.currentState?.validate(),
                    hintText: "Contact No (with country code)",
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter contact number";
                      } else if (value.trim().length < 7) {
                        return "Enter valid contact number with country code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: AppColors.brown,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            "Add mobile number with country code (e.g. +91 9876543210)",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: inquiryProvider.messageController,
                    onChanged: (value) => formKey.currentState?.validate(),
                    hintText: "Message",
                    maxLines: 3,
                    validator:
                        (value) => value!.isEmpty ? "Enter message" : null,
                  ),
                  const SizedBox(height: 20),
                  // Request Sample Checkbox
                  Row(
                    children: [
                      Checkbox(
                        // activeColor: WidgetStatePropertyAll(AppColors.brown),
                        activeColor: AppColors.brown,
                        value: inquiryProvider.requestSample,
                        onChanged:
                            (bool? value) =>
                                inquiryProvider.setRequestSample =
                                    value ?? false,
                      ),
                      const Text("Request Sample"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 50 : 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C3F2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await inquiryProvider.sendInquiry(
                            id: productId,
                            productName: productName,
                            url: category,
                            sampleRequest: inquiryProvider.requestSample,
                            context: context,
                          );
                        }
                      },
                      child:
                          inquiryProvider.isLoading
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Submit",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: isTablet ? 17 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
