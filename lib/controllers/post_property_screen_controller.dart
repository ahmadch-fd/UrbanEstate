import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPropertyController extends GetxController {
  // ─── Stepper ───────────────────────────────────────────────
  final RxInt currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 3) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void goToStep(int step) => currentStep.value = step;

  // ─── Step 1 – Property Details ─────────────────────────────
  final Rx<String?> availableFrom = Rx<String?>(null);
  final Rx<String?> propertyType = Rx<String?>(null);
  final Rx<String?> bedrooms = Rx<String?>(null);
  final Rx<String?> bathrooms = Rx<String?>(null);
  final Rx<String?> balcony = Rx<String?>(null);
  final Rx<String?> floorNo = Rx<String?>(null);
  final sizeController = TextEditingController();

  final List<String> availableFromOptions = [
    'Immediately',
    'Within 1 Month',
    'Within 3 Months',
    'Within 6 Months',
  ];
  final List<String> propertyTypeOptions = [
    'Apartment',
    'House',
    'Villa',
    'Studio',
    'Penthouse',
  ];
  final List<String> bedroomOptions = ['1', '2', '3', '4', '5', '6+'];
  final List<String> bathroomOptions = ['1', '2', '3', '4', '5+'];
  final List<String> balconyOptions = ['Yes', 'No'];
  final List<String> floorOptions = [
    'Ground',
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th+',
  ];

  // ─── Step 2 – Location ─────────────────────────────────────
  final Rx<String?> division = Rx<String?>(null);
  final Rx<String?> district = Rx<String?>(null);
  final Rx<String?> area = Rx<String?>(null);
  final sectorController = TextEditingController();
  final roadController = TextEditingController();
  final houseNoController = TextEditingController();
  final houseNameController = TextEditingController();

  final List<String> divisionOptions = [
    'Dhaka',
    'Chittagong',
    'Rajshahi',
    'Khulna',
    'Sylhet',
    'Barishal',
    'Mymensingh',
    'Rangpur',
  ];
  final List<String> districtOptions = [
    'Select Division First',
  ];
  final List<String> areaOptions = ['Select District First'];

  void onDivisionChanged(String? value) {
    division.value = value;
    district.value = null;
    area.value = null;
  }

  void onDistrictChanged(String? value) {
    district.value = value;
    area.value = null;
  }

  // ─── Step 3 – Pricing ──────────────────────────────────────
  final priceController = TextEditingController();
  final Rx<String?> priceFor = Rx<String?>(null);
  final RxBool electricityBill = false.obs;
  final RxBool gasBill = false.obs;
  final RxBool waterBill = false.obs;

  final List<String> priceForOptions = [
    'Per Month',
    'Per Year',
    'Total Price',
  ];

  void toggleElectricity() => electricityBill.value = !electricityBill.value;
  void toggleGas() => gasBill.value = !gasBill.value;
  void toggleWater() => waterBill.value = !waterBill.value;

  // ─── Step 4 – Features & Submit ────────────────────────────
  final RxSet<String> selectedFeatures = <String>{}.obs;
  final descriptionController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  final List<Map<String, dynamic>> featureOptions = [
    {'label': 'LIFT', 'icon': Icons.elevator},
    {'label': 'GARAGE', 'icon': Icons.garage},
    {'label': 'CCTV', 'icon': Icons.videocam},
    {'label': 'GAS', 'icon': Icons.local_fire_department},
    {'label': 'WIFI', 'icon': Icons.wifi},
    {'label': 'GYM', 'icon': Icons.fitness_center},
    {'label': 'POOL', 'icon': Icons.pool},
    {'label': 'SECURITY', 'icon': Icons.security},
  ];

  void toggleFeature(String feature) {
    if (selectedFeatures.contains(feature)) {
      selectedFeatures.remove(feature);
    } else {
      selectedFeatures.add(feature);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  void removeImage() => selectedImage.value = null;

  void submitForm() {
    Get.snackbar(
      'Success!',
      'Your property has been posted successfully.',
      backgroundColor: const Color(0xFF1A4731),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // ─── Validation ────────────────────────────────────────────
  bool validateStep1() {
    if (availableFrom.value == null) {
      _showError('Please select Available From');
      return false;
    }
    if (propertyType.value == null) {
      _showError('Please select Type of Property');
      return false;
    }
    if (bedrooms.value == null) {
      _showError('Please select Bedrooms');
      return false;
    }
    if (bathrooms.value == null) {
      _showError('Please select Bathrooms');
      return false;
    }
    return true;
  }

  bool validateStep2() {
    if (division.value == null) {
      _showError('Please select Division');
      return false;
    }
    return true;
  }

  bool validateStep3() {
    if (priceController.text.trim().isEmpty) {
      _showError('Please enter Price');
      return false;
    }
    if (priceFor.value == null) {
      _showError('Please select Price For');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    sizeController.dispose();
    sectorController.dispose();
    roadController.dispose();
    houseNoController.dispose();
    houseNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}