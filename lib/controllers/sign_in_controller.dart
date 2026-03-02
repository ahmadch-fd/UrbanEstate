import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> informKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void clearfields() {
    emailController.clear();
    passwordController.clear();
  }
}
