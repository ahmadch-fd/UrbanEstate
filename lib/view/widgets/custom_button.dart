import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';

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
    final responsive = Responsive.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: responsive.buttonHeight,
        width: responsive.authFieldWidth,
        decoration: BoxDecoration(
          // color: AppColors.primaryButtonColor,
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: poppinsSemiBold.copyWith(
              fontSize: responsive.font(18),
              // color: AppColors.mainTextColor,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
