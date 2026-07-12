import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/best_houses_cards.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/home_section_header.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/recent_house_card.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/recent_all_view_screen.dart';

class HomeDefaultSections extends StatelessWidget {
  const HomeDefaultSections({
    super.key,
    required this.properties,
    required this.responsive,
  });

  final List<PostedProperty> properties;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final itemCount = properties.isEmpty ? 3 : properties.length;

    return SliverList(
      delegate: SliverChildListDelegate([
        HomeSectionHeader(
          title: 'Recent',
          responsive: responsive,
          onViewAll: () => Get.to(() => const RecentAllview(recentOnly: true)),
        ),
        SizedBox(height: responsive.sectionGap),
        const RecentHouseCard(),
        SizedBox(height: responsive.space(18)),
        HomeSectionHeader(
          title: 'Best for you',
          responsive: responsive,
          onViewAll: () => Get.to(() => const RecentAllview()),
        ),
        SizedBox(height: responsive.sectionGap),
        ...List.generate(
          itemCount,
          (index) => BestForYouCard(
            index: index,
            property: properties.isEmpty ? null : properties[index],
          ),
        ),
      ]),
    );
  }
}
