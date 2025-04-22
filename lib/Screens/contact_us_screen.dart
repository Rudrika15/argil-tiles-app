import 'package:argil_tiles/model/contact_model.dart';
import 'package:argil_tiles/sevices/contact_service.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final contact = ContactModel(
        name: _nameController.text,
        email: _emailController.text,
        contactno: _contactNoController.text,
        message: _messageController.text,
      );

      final success = await ContactService().submitContact(contact);

      setState(() => _isLoading = false);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Message sent successfully!'
              : 'Failed to send message. Try again.'),
        ),
      );

      if (success) {
        _formKey.currentState?.reset();
        _nameController.clear();
        _emailController.clear();
        _contactNoController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: const BackButton(),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "for more information you can\nreach out to us",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(children: [
                _buildInputField(
                  controller: _nameController,
                  hint: "Name",
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your name' : null,
                ),
                _buildInputField(
                  controller: _emailController,
                  hint: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    } else if (!_emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _contactNoController,
                  hint: "Contact No",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your contact number';
                    } else if (value.length < 10) {
                      return 'Enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _messageController,
                  hint: "Message",
                  maxLines: 4,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter a message' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF663333),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 30),
            _buildContactDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7E3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: const [
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 10),
              Text('+91 2822 240628/29'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 10),
              Text('info@argiltiles.com'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mod Ceramic Industries Ltd.\n8-A, National Highway,\nMorbi (Gujarat), India 363 642',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
