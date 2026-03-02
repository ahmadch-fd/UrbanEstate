import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  RxString imagePath = ''.obs;
  Future pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imagePath.value = image.path.toString();
      Get.back();
    }
  }
}
