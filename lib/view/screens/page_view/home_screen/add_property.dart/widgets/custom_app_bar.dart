import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: height * 0.08,
              width: width,
              decoration: BoxDecoration(color: AppColors.appbartext_color),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  textAlign: TextAlign.center,
                  'Post Your Property',
                  style: poppinsRegular.copyWith(
                    fontSize: 18,
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
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.forestGreen,
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
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
