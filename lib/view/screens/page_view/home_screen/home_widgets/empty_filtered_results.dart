import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/utils/responsive.dart';

class EmptyFilteredResults extends StatelessWidget {
  const EmptyFilteredResults({super.key, required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.space(18)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          'No properties found for this category.',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: responsive.font(13),
          ),
        ),
      ),
    );
  }
}
