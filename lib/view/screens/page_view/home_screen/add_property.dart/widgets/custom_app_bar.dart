import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: responsive.scale(64),
              width: responsive.width,
              decoration: BoxDecoration(color: AppColors.appbartext_color),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  textAlign: TextAlign.center,
                  'Post Your Property',
                  style: poppinsRegular.copyWith(
                    fontSize: responsive.font(18),
                    color: AppColors.bgColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 7,
            child: GestureDetector(
              onTap: () {
                if (Get.isRegistered<PostPropertyController>()) {
                  Get.find<PostPropertyController>().resetForm();
                }
                Get.find<OnboardingController>().changePage(0);
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.forestGreen,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
