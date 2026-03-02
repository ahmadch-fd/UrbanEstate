import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    required this.color,
    required this.textColor,
  });
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.065,
        width: width * 0.82,
        decoration: BoxDecoration(
          // color: AppColors.primaryButtonColor,
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: poppinsSemiBold.copyWith(
              fontSize: 18,
              // color: AppColors.mainTextColor,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
