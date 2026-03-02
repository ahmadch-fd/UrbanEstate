import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/controllers/name&location_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class NameLocationColumn extends StatelessWidget {
  const NameLocationColumn({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final NameLocationController controller = Get.put(NameLocationController());

    return Column(
      children: [
        Obx(
          () => Text(
            controller.nameController.value.text.isEmpty
                ? 'John Doe'
                : controller.nameController.value.text,
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
            Text(
              'Manhattan, New York',
              style: poppinsLite.copyWith(color: AppColors.bgColor),
            ),
          ],
        ),
      ],
    );
  }
}
