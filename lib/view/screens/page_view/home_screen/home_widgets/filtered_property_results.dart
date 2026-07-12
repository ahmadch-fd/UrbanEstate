import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/best_houses_cards.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/empty_filtered_results.dart';

class FilteredPropertyResults extends StatelessWidget {
  const FilteredPropertyResults({
    super.key,
    required this.title,
    required this.properties,
    required this.responsive,
  });

  final String title;
  final List<PostedProperty> properties;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: responsive.font(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: responsive.sectionGap),
        if (properties.isEmpty)
          EmptyFilteredResults(responsive: responsive)
        else
          ...List.generate(
            properties.length,
            (index) =>
                BestForYouCard(index: index, property: properties[index]),
          ),
      ]),
    );
  }
}
