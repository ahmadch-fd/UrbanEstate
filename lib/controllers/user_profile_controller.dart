import 'dart:io';

import 'package:get/get.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/models/app_profile.dart';
import 'package:urban_estate/services/profile_service.dart';

class UserProfileController extends GetxController {
  final Rxn<AppProfile> profile = Rxn<AppProfile>();
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  String? _loadedUserId;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile({bool force = false}) async {
    final currentUserId = AuthService.currentUser?.id;
    if (currentUserId == null) {
      clearProfile();
      return;
    }

    if (!force && _loadedUserId == currentUserId && profile.value != null) {
      return;
    }

    profile.value = null;
    isLoading.value = true;
    try {
      profile.value = await ProfileService.currentProfile();
      _loadedUserId = currentUserId;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveProfile({
    required String fullName,
    required String phone,
    required String location,
    required String dateOfBirth,
    String imagePath = '',
  }) async {
    isSaving.value = true;
    try {
      await ProfileService.updateCurrentProfile(
        fullName: fullName,
        phone: phone,
        location: location,
        dateOfBirth: dateOfBirth,
        avatarImage: imagePath.isEmpty ? null : File(imagePath),
      );
      await loadProfile(force: true);
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void clearProfile() {
    profile.value = null;
    _loadedUserId = null;
    isLoading.value = false;
    isSaving.value = false;
  }
}
