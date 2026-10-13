import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:argil_tiles/widgets/water_mark_logo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GroupCompanyScreen extends StatelessWidget {
  const GroupCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final TextStyle headingStyle = TextStyle(
      fontSize: isTablet ? 21 : 16,
      fontWeight: FontWeight.bold,
    );
    final TextStyle subHeadingStyle = TextStyle(
      fontSize: isTablet ? 16 : 14,
      fontStyle: FontStyle.italic,
    );
    final TextStyle bodyStyle = TextStyle(
      fontSize: isTablet ? 17 : 14,
      height: 1.5,
    );

    return PopAndRedirectToHome(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6F1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: isTablet ? 26 : 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Group Company',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: isTablet ? 28 : 24,
                    ),
                    onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                  ),
            ),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: const DrawerWidget(),
        body: Stack(
          children: [
            const WaterMarkLogo(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 780 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 28.0 : AppSize.size20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Image(
                            image: const AssetImage('assets/images/logo.png'),
                            height: isTablet ? 12.h : 10.h,
                          ),
                        ),
                      ),
                      Text(
                        "The company has three manufacturing units. The Roof Tile, Wall tiles and the Quartz Stone Unit. All the units have a very strong and industrious infrastructure that is instrumental in making the company and the brand, leading players in their respective product lines across India and overseas...",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("MEN", style: headingStyle),
                      Text("“Hands that work are never dirty”", style: subHeadingStyle),
                      const SizedBox(height: 8),
                      Text(
                        "The operatives of the company, many of them working since more than 20 years, are all part of the success story of ARGIL. They are well treated and trained to always improve their productivity and hence their income as well. They put their best efforts with quality perspective so that the output is acceptable and rejection is low. They are well gelled with the supervisors and the middle management. The top management being approachable to them makes them all the more happy to work at ARGIL. In alignment with the company principles, they have a very good work life balance.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("Machines", style: headingStyle),
                      Text(
                        "“Leveraging Human Effort through Efficient use of Technology”",
                        style: subHeadingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Machines make work easy, fast, accurate and stress free for the humans. When machines are adopted from best supplier and leaders in technology, the output is always the best. ARGIL has always preferred to go for the best in all inputs. Technology is their single most scaled investment avenue. The company has the latest and the most modern technology adoption practice. The technological Strength of the group is very well highlighted in the profile of each plant.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("Prajapat Tiles", style: headingStyle),
                      Text("Commencement : 1951", style: subHeadingStyle),
                      const SizedBox(height: 8),
                      Text(
                        "Being the pioneering effort of the group, this is the most loved of all the production units of the founders. It is the manufacturer and supplier of CHAKRA brand of roof tiles. CHAKRA is the most famous roof tiles brand in India. One of the oldest and richest in tradition, it has established and maintained its leadership status in the roof tiles segment. With more than 50 shapes and sizes to boast of, it embellishes roofs of thousands of homes around India. Keeping the homes cool and protected as well as doing it the natural way, the CHAKRA brand roof tiles have entered Indian hearts as well.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("Argil Tiles : Mod Ceramic Industries Ltd.", style: headingStyle),
                      Text("Commencement: 1991", style: subHeadingStyle),
                      const SizedBox(height: 8),
                      Text(
                        "The wall tiles unit started in 1991 and was the first plant in the morbi region is spread in 50,000 Sq. Mts. and has all the facilities of the most modern plant having a capacity of manufacturing 2,40,000 sq.mts per month. With ample material movement space, storage facilities and productive machines laid out in a systematic and organized manner, the company can smoothly manufacture and dispatch large quantities of tiles. The men and Material flow is seamlessly set for most efficient operational management. Running as an independent unit, the infrastructure of the plant is upgraded regularly to keep up with the changing needs as well as new technology available.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("Argil Ceramics", style: headingStyle),
                      Text("Commencement: 2010", style: subHeadingStyle),
                      const SizedBox(height: 8),
                      Text(
                        "The Quartz Stone Unit is relatively freshly set up and hence boasts of being more modern and advanced in comparison. It is established on 40,000 Sq mtr. Area, with state of the art technology and well-planned layout of equipments and storage areas as well as material and men movement sections defined, it has flawless production running round the clock. The inherent advantage of the plant being set up by professionals from day one is its extremely efficient and without any bottle necks of adjustments, making it more efficient and empowering larger production.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text("Quartz Stone", style: headingStyle),
                      const SizedBox(height: 8),
                      Text(
                        "When the beauty of nature demands to be in every life technology is used to create the beauty in every life. Argil DuraQuartz Surface is one such product that combines the elegance of nature into excellent tiling solutions with the employment of Quartz Technology. The QUARTZ STONE unit has evolved to deliver to the world the best of nature in forms of stone slabs that are a replica of natural stones like granite and marbles. For the same we have used state of the art technology, thus fulfilling our own growth principle of Tradition to Technology.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "With years of research, lot of perseverance and huge amount of investment we have mastered the art of blending the aesthetics of nature, power of technology and human creativity into a great product-line that is Argil DuraQuartz Surfaces.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Argil DuraQuartz Surface is a high-quailty nonporous, composite material, built-up from hard, inorganic, polishable granulates, compactly bound together with a binder and a filler, coloured with various eco-conscious pigments. It has a smooth, stain resistant surface, comes in a variety of sizes and has a wide range of applications. An incredible mix of long lasting durability and breathtaking aesthetics, Argil DuraQuartz Surfaces is just the right choice for those who love to experience the best things in life. Already a global trend in innovative surface material, engineered quartz surface material is quickly becoming the new status symbol for style. Argil DuraQuartz Surfaces proudly brings you the global surface-fashion statement to turn your desires into stunning realities.",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "The SLABS of Quartz Stone from ARGIL are a revolutionary product. Durable, with great surface quality and most of all machin ability makes them the most suitable substitute of Natural Stone. Below are the USP's ARGIL Duraquartz Surfaces:",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "• Scratch Resistance\n"
                        "• Stain Resistance\n"
                        "• Chip and Crack Resistance\n"
                        "• Heat and Burn Resistance\n"
                        "• Resistance to household chemicals, acids and solvents\n"
                        "• Low maintenance\n"
                        "• Non-porous\n"
                        "• High flexural strength\n"
                        "• Glossiness\n"
                        "• Color consistency\n"
                        "• Immunity to freeze and thaw",
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "They come in jumbo sizes of 3000 x 1300 mm and 3200 x 1600 mm also it can be customized as per requirement. They find applications in big table tops kitchen tops and the like. They can be resized, cut, beveled like any stone. Custom sizes for the stone are also available. The tiles can be of 300x300 mm, 300x600 mm, 600x600 mm, 800x800 mm.",
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
