import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/provider/product_inquiry_provider.dart';
import 'package:argil_tiles/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'custom_container.dart';

class InquiryForm extends StatelessWidget {
  InquiryForm({super.key, required this.productName, required this.category,required this.productId});
  final String productName;
  final int productId;
  final String category;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ProductInquiryProvider inquiryProvider =
        context.watch<ProductInquiryProvider>();
    return CustomContainer(
      width: 80.w,
      padding: const EdgeInsets.all(AppSize.size10),
      backGroundColor: Color(0xFFF9F4EF),
      borderRadius: BorderRadius.circular(AppSize.size10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Product Inquiry",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              "Please let us know if you have any questions.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: inquiryProvider.nameController,
                    hintText: "Name",
                    validator: (value) => value!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: inquiryProvider.emailController,
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
                    hintText: "Contact No",
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator:
                        (value) =>
                            value!.length != 10
                                ? "Enter valid 10-digit contact number"
                                : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: inquiryProvider.messageController,
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C3F2B),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await inquiryProvider.sendInquiry(
                            id: productId,
                            productName: productName,
                            url: category,
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
                              : const Text(
                                "Submit",
                                style: TextStyle(color: AppColors.whiteColor),
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
