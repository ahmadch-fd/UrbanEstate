import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/best_houses_cards.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/categories_list_view.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/recent_house_card.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/recent_allView_screen.dart';
import 'package:urban_estate/view/widgets/search_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.forestGreen,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Find Your \nDream House',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: width * 0.4),
                      Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          height: height * 0.06,
                          child: SearchTextField(text: 'Search',),
                        ),
                        SizedBox(width: width * 0.05),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.filter_list,
                            color: AppColors.mainTextColor,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: height * 0.014), // 4% of screen height
              ),
              SliverToBoxAdapter(child: CategorySelector()),
              SliverToBoxAdapter(child: SizedBox(height: height * 0.014)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          'Recent',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const RecentAllview());
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: height * 0.014)),
              SliverToBoxAdapter(child: RecentHouseCard()),
              SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Best for you',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'View All',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: height * 0.014)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const BestForYouCard(),
                  childCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
