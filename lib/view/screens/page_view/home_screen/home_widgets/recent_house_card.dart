import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/view/screens/page_view/product_detail/product_detail_screen.dart';

class RecentHouseCard extends StatelessWidget {
  const RecentHouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    List networkImagelength = [
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    ];
    List<String> housetype = ['Dreamsville House', 'Sunset Villa'];
    List<String> priceshouse = ['\$3,850', '\$4,200'];
    List<String> locationshouse = [
      'Jl. Sultan Iskandar Muda',
      'Jl. Pantai Indah Kapuk',
    ];
    List<String> buytype = ['Monthly Rent', 'For Sale'];

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) => Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 8.0)
              : const EdgeInsets.only(left: 0.0),
          child: Container(
            width: width * 0.8,
            height: height * 0.18, // Fixed width for horizontal scrolling
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(networkImagelength[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay to make text readable
                GestureDetector(
                  onTap: () {
                    Get.to(PropertyDetailsScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 1),
                        ],
                      ),
                    ),
                  ),
                ),
                // Property Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            housetype[index],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            priceshouse[index],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locationshouse[index],
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            buytype[index],
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
