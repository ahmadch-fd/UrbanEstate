import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/services/profile_service.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;
  Rx<bool> hasAcceptedTerms = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  Future<bool> signUp() async {
    if (!hasAcceptedTerms.value) {
      _showError('Please accept the Terms & Conditions before signing up.');
      return false;
    }

    isLoading.value = true;
    try {
      final response = await AuthService.signUp(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user == null) {
        _showError('Unable to create account. Please try again.');
        return false;
      }

      await ProfileService.upsertCurrentProfile(
        fullName: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      clearfields();
      return true;
    } on AuthException catch (error) {
      _showError(error.message);
      return false;
    } catch (_) {
      _showError('Something went wrong. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearfields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmpassController.clear();
    hasAcceptedTerms.value = false;
  }

  void _showError(String message) {
    Get.snackbar(
      'Sign Up Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

}
