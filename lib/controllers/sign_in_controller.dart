import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/controllers/user_profile_controller.dart';
import 'package:urban_estate/services/auth_service.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> informKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> signIn() async {
    isLoading.value = true;
    try {
      final response = await AuthService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user == null) {
        _showError('Unable to sign in. Please try again.');
        return false;
      }

      await Get.put(
        UserProfileController(),
        permanent: true,
      ).loadProfile(force: true);
      await Get.put(PropertyListingController(), permanent: true).fetchFeed();

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
    emailController.clear();
    passwordController.clear();
  }

  void _showError(String message) {
    Get.snackbar(
      'Sign In Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
