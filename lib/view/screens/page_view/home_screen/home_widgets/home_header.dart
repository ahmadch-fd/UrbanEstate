import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/widgets/search_text_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.responsive,
    required this.onFilterTap,
  });

  final Responsive responsive;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.only(
            left: responsive.pagePadding,
            right: responsive.pagePadding,
            top: responsive.space(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Find Your \nDream House',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: responsive.font(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Icon(
              //   Icons.notifications_none,
              //   color: Colors.white,
              //   size: responsive.icon(28),
              // ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.pagePadding,
            responsive.space(20),
            responsive.pagePadding,
            0,
          ),
          child: Row(
            children: [
              const Expanded(child: SearchTextField(text: 'Search')),
              SizedBox(width: responsive.space(14)),
              InkWell(
                onTap: onFilterTap,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: responsive.icon(24),
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.filter_list,
                    color: AppColors.mainTextColor,
                    size: responsive.icon(28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
