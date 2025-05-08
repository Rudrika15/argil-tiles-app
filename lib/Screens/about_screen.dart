import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          title: const Text('About Us'),
          leading: const BackButton(),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
            ),
          ],
        ),
        endDrawer: DrawerWidget(),
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
                    "People destined to create history are always blessed with astute vision of things to come and determination to articulate the vision into reality. Shri Amarshibhai was no different. While still employed, he saw a heap of Mangalore roof tiles, which were manufactured in Mangalore, South India only. Mangalore roofing tiles' main ingredient was black and red clay, which was available in abundance in Morbi. The nearness to the raw material and his technical know-how of clay encouraged him to start his own production of roofing tiles.\n\n "
                    "With the zeal of an entrepreneur, he returned to Morbi. With numerous trials, lot of experimentation and tremendous research, he could not design the best product or the system to mass manufacture roof tiles. While many would have given up, he was not the one to throw in the towel. He worked harder ever determined to make something big. Finally, he succeeded in developing durable beautiful Mangalore Tile. He also devised a very efficient production system to mass manufacture tiles. Trained man power was available in Morbi and that acted as a strong catalyst to start fast.\n\n"
                    "Prajapat Tiles Company was formed in 1952. Funding was the biggest challenge as the Family had very little saved. Most of the initial capital was borrowed and a small manufacturing unit was commissioned by Shri Prajapati and his team. Being the first of its kind manufacturing unit in the region and a very heavy demand of Mangalore tiles, 100% production was sold.\n\n"
                    "The founder had witnessed good & bad days. He never wished his brothers to go through the terrible struggle hence he started training his brothers, technically and commercially. Each of them was given a separate unit to manage. In modern day management we would term these as profit centers and each brother a profit centre head. The flagship company though remained Prajapat Tiles Co.\n\n"
                    "Stability is a limiting belief for those with big dreams and an even greater appetite for betterment of life. The founder did not rest on the laurels of this achievement. In the year 1999 he established ARGIL brand which manufactured and supplied high quality wall tiles. It is one of the most admired wall tile brands in India today.\n\n"
                    "Innovation and growth always go hand in hand. In the year 2010 the company ahs recently launched Quartz Stone unit. The first of its kind in India, it has the most vibrant product range in the segment.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
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
