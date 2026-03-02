// ... imports stay the same
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/recent_allView_widgets/house_lists.dart ';
import 'package:urban_estate/view/screens/page_view/home_screen/recent_allView_widgets/sliver_persistent.dart';
import 'package:urban_estate/view/widgets/search_text_field.dart ';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:flutter/material.dart';

class RecentAllview extends StatelessWidget {
  const RecentAllview({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 1. NON-STICKY HEADER SECTION
              SliverPersistentHeader(
                pinned: false, // CHANGED: Now it will scroll away
                floating:
                    true, // Ensures it doesn't pop back in when scrolling up
                delegate: MySliverDelegate(
                  height: height * 0.12,
                  child: Container(
                    color: const Color.fromARGB(255, 221, 234, 230),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(child: SearchTextField(text: 'Search Home')),
                        const SizedBox(width: 15),
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

              // 2. RESULTS COUNT SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  child: Text(
                    '1212 Results...',
                    style: poppinsRegular.copyWith(
                      color: AppColors.mainTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // 3. SCROLLABLE LIST
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const HouseLists(),
                    childCount: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
