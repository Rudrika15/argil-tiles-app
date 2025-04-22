import 'package:argil_tiles/model/product_inquiry_model.dart';
import 'package:argil_tiles/provider/product_inquiry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInquiryScreen extends StatefulWidget {
  const ProductInquiryScreen({super.key});

  @override
  ProductInquiryScreenState createState() => ProductInquiryScreenState();
}

class ProductInquiryScreenState extends State<ProductInquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  bool _requestSample = false; // To track checkbox state

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ProductInquiryProvider>(
        context,
        listen: false,
      );

      final inquiry = ProductInquiryModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _contactController.text.trim(),
        message: _messageController.text.trim(),
        subject: "Product Inquiry",
        details: "Additional product details",
        requestSample: _requestSample, // Pass the requestSample state
      );

      await provider.sendInquiry(inquiry);

      if (provider.isSuccess) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquiry submitted successfully!")),
        );
        _formKey.currentState!.reset();
      } else if (provider.errorMessage != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Consumer<ProductInquiryProvider>(
          builder: (context, provider, _) {
            return Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F4EF),
                borderRadius: BorderRadius.circular(15),
              ),
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
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          _nameController,
                          "Name",
                          validator: (value) => value!.isEmpty ? "Enter name" : null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          _emailController,
                          "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter email";
                            }
                            final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                            return emailRegex.hasMatch(value) ? null : "Enter valid email";
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          _contactController,
                          "Contact No",
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.length != 10 ? "Enter valid 10-digit contact number" : null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          _messageController,
                          "Message",
                          maxLines: 3,
                          validator: (value) => value!.isEmpty ? "Enter message" : null,
                        ),
                        const SizedBox(height: 20),
                        // Request Sample Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _requestSample,
                              onChanged: (bool? value) {
                                setState(() {
                                  _requestSample = value!;
                                });
                              },
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
                            onPressed: provider.isLoading ? null : () => _submitForm(context),
                            child: provider.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
    );
  }
}
