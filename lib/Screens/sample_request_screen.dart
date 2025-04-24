import 'package:argil_tiles/Screens/product_inquiry_screen.dart';
import 'package:flutter/material.dart';

class SampleRequestScreen extends StatelessWidget {
  const SampleRequestScreen({super.key});

  void showSampleRequestDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Would you like to request a sample of our product?",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  ProductInquiryScreen(),
                        ),
                        (route) => false, 
                      );
                    },
                    child: const Text("Yes",
                    style: TextStyle(color: Colors.black)),
                  ),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",
                    style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Request"),
      backgroundColor: const Color(0xFFD3C8BA),),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showSampleRequestDialog(context),
          child: Text("Request Sample",
          style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}
