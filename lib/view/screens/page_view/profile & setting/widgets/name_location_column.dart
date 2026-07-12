import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/user_profile_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class NameLocationColumn extends StatelessWidget {
  const NameLocationColumn({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController(), permanent: true);

    return Column(
      children: [
        Obx(
          () => Text(
            controller.profile.value?.fullName.isNotEmpty ?? false
                ? controller.profile.value!.fullName
                : 'Your Profile',
            style: poppinsRegular.copyWith(color: Colors.black, fontSize: 16),
          ),
        ),
        SizedBox(height: height * 0.00),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.bgColor,
              size: 16,
            ),
            Obx(
              () => Text(
                controller.profile.value?.location.isNotEmpty ?? false
                    ? controller.profile.value!.location
                    : controller.profile.value?.email ?? '',
                style: poppinsLite.copyWith(color: AppColors.bgColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
