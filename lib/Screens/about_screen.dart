import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/logo.png',
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 100,
                ),
                SizedBox(height: 24),
                Text(
                  "India's greatest entrepreneurial stories are all epics within themselves. One of those is the story of the Argil Group of companies. Shri Motbhai Prajapati was a potter at Sultanpur, a very small village. He was blessed with a son, who was destined to create history in the region. We know him now as Shri Amarshibhai Prajapati. Since a young age, he was helping his father in the work of pottery, where he attained technical expertise in the workings of clay. His father shifted to Morbi, employed at Parshuram Pottery. The family and the young boy too moved to the place where he would later set up one of the most admired ceramic brands of the world.\n\n"
                  "Shri Amarshibhai too worked in the same factory for 8 to 10 years, working in different roles, ranging from a manufacturer of glazed jars to plaster turning moulder. He moved on to Junagadh District to serve as a moulder for 2 years in Kathiawad Industries Ltd.\n\n"
                  "People destined to create history are always blessed with astute vision of things to come and determination to articulate the vision into reality. Shri Amarshibhai was no different. While still employed, he saw a heap of Mangalore roof tiles, which were manufactured in Mangalore, South India only. Mangalore roofing tiles' main ingredient was black and red clay, which was available in abundance in Morbi. The nearness to the raw material and his technical know-how of clay encouraged him to start his own production of roofing tiles.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
