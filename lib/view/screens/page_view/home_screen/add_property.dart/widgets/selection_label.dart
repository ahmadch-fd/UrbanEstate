import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.forestGreen,
      ),
    );
  }
}
