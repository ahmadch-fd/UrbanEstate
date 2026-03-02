import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameLocationController extends GetxController {
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final TextEditingController locationController = TextEditingController();

  // var name = "".obs;

  // @override
  // void onInit() {
  //   nameController.addListener(() {
  //     name.value = nameController.value.text;
  //   });
  //   super.onInit();
  // }

  @override
  void onClose() {
    nameController.value.clear();
    locationController.clear();
    super.onClose();
  }
}
