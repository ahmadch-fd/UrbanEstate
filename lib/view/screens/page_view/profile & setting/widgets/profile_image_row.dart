import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/controllers/user_profile_controller.dart';

class ProfileImageRow extends StatelessWidget {
  const ProfileImageRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePickerController controller = Get.put<ImagePickerController>(
      ImagePickerController(),
      permanent: true,
    );
    final profileController = Get.put(UserProfileController(), permanent: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          final imagePath = controller.imagePath.value;
          final avatarUrl = profileController.profile.value?.avatarUrl;

          return CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE9D7FF),
            backgroundImage: _avatarImage(imagePath, avatarUrl),
            child: imagePath.isEmpty && (avatarUrl == null || avatarUrl.isEmpty)
                ? const Icon(Icons.person, size: 44, color: Colors.white)
                : null,
          );
        }),
      ],
    );
  }
}

ImageProvider? _avatarImage(String imagePath, String? avatarUrl) {
  if (imagePath.isNotEmpty) {
    return FileImage(File(imagePath));
  }

  if (avatarUrl != null && avatarUrl.isNotEmpty) {
    return NetworkImage(avatarUrl);
  }

  return null;
}
