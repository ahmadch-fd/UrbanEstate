import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';

class ProfileImageRow extends StatelessWidget {
  const ProfileImageRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePickerController controller = Get.put<ImagePickerController>(
      ImagePickerController(),
      permanent: true,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return CircleAvatar(
            radius: 50,
            backgroundImage: controller.imagePath.isNotEmpty
                ? FileImage(File(controller.imagePath.value)) as ImageProvider
                : AssetImage('placeholder_path'),
          );
        }),
      ],
    );
  }
}
