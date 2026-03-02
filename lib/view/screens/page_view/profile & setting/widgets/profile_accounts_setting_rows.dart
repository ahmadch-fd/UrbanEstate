import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class ProfileAccountsSettingRows extends StatelessWidget {
  const ProfileAccountsSettingRows({
    super.key,
    required this.width,
    required this.icon,
    required this.text,
    required this.ontap,
  });

  final double width;
  final IconData icon;
  final String text;
  final VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 25, color: AppColors.bgColor.withValues(alpha: 0.4)),
        SizedBox(width: width * 0.1),
        InkWell(
          onTap: ontap,
          child: Text(
            text,
            style: poppinsRegular.copyWith(
              color: AppColors.bgColor.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ),

        // SizedBox(width: width * 0.3),
        //  NotificationSwitch(),
      ],
    );
  }
}
