import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/services/location_service.dart';
import 'package:urban_estate/services/price_prediction_service.dart';
import 'package:urban_estate/services/property_service.dart';
import 'package:urban_estate/services/profile_service.dart';

class PostPropertyController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;
  final List<Worker> _predictionResetWorkers = [];

  void nextStep() {
    if (currentStep.value < 3) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void goToStep(int step) {
    currentStep.value = step.clamp(0, 3);
  }

  void resetForm() {
    currentStep.value = 0;
    tenantType.value = null;
    propertyType.value = null;
    bedrooms.value = null;
    bathrooms.value = null;
    availableFrom.value = null;
    balcony.value = null;
    floorNo.value = null;
    provinceName.value = null;
    city.value = null;
    locationController.clear();
    latitudeController.clear();
    longitudeController.clear();
    purpose.value = null;
    priceFor.value = null;
    sizeController.clear();
    ageOfHouseController.clear();
    priceController.clear();
    electricityBill.value = false;
    gasBill.value = false;
    waterBill.value = false;
    pricePrediction.value = null;
    selectedFeatures.clear();
    descriptionController.clear();
    selectedImages.clear();
  }

  // Step 1: basic property details.
  final Rx<String?> tenantType = Rx<String?>(null);
  final Rx<String?> propertyType = Rx<String?>(null);
  final Rx<String?> bedrooms = Rx<String?>(null);
  final Rx<String?> bathrooms = Rx<String?>(null);
  final Rx<String?> availableFrom = Rx<String?>(null);
  final Rx<String?> balcony = Rx<String?>(null);
  final Rx<String?> floorNo = Rx<String?>(null);

  final List<String> propertyTypeOptions = [
    'House',
    'Flat',
    'Apartment',
    'Upper Portion',
    'Lower Portion',
    'Farm House',
  ];
  final List<String> tenantTypeOptions = [
    'Bachelor',
    'Family',
    'Office',
    'Sublet',
  ];
  final List<String> bedroomOptions = ['1', '2', '3', '4', '5', '6+'];
  final List<String> bathroomOptions = ['1', '2', '3', '4', '5+'];
  final List<String> availableFromOptions = [
    'Immediately',
    'Within 1 Month',
    'Within 3 Months',
    'Within 6 Months',
  ];
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

  // Step 2: model location inputs.
  final Rx<String?> provinceName = Rx<String?>(null);
  final Rx<String?> city = Rx<String?>(null);
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final RxMap<String, List<String>> citiesByProvince =
      Map<String, List<String>>.from(
        LocationService.fallbackProvinceCities,
      ).obs;

  List<String> get provinceOptions => citiesByProvince.keys
      .where((province) => province.trim().isNotEmpty)
      .toSet()
      .toList();

  List<String> get cityOptions {
    final province = provinceName.value;
    if (province == null || province.isEmpty) return const [];

    return (citiesByProvince[province] ?? const <String>[])
        .where((cityName) => cityName.trim().isNotEmpty)
        .toSet()
        .toList();
  }

  void onProvinceChanged(String? value) {
    provinceName.value = value;
    city.value = null;
  }

  Future<void> loadLocationOptions() async {
    final locations = await LocationService.provinceCities();
    final cleanedLocations = <String, List<String>>{};
    for (final entry in locations.entries) {
      final province = entry.key.trim();
      final cities = entry.value
          .where((cityName) => cityName.trim().isNotEmpty)
          .map((cityName) => cityName.trim())
          .toSet()
          .toList();
      if (province.isNotEmpty && cities.isNotEmpty) {
        cleanedLocations[province] = cities;
      }
    }

    citiesByProvince.assignAll(cleanedLocations);
    if (!citiesByProvince.containsKey(provinceName.value)) {
      provinceName.value = null;
      city.value = null;
    } else if (!cityOptions.contains(city.value)) {
      city.value = null;
    }
  }

  // Step 3: prediction inputs plus display-only price information.
  final Rx<String?> purpose = Rx<String?>(null);
  final Rx<String?> priceFor = Rx<String?>(null);
  final sizeController = TextEditingController();
  final ageOfHouseController = TextEditingController();
  final priceController = TextEditingController();
  final RxBool electricityBill = false.obs;
  final RxBool gasBill = false.obs;
  final RxBool waterBill = false.obs;
  final RxBool isPredictingPrice = false.obs;
  final Rxn<PricePrediction> pricePrediction = Rxn<PricePrediction>();

  final List<String> purposeOptions = ['For Sale', 'For Rent'];
  final List<String> priceForOptions = ['Per Month', 'Per Year', 'Total Price'];

  void toggleElectricity() => electricityBill.value = !electricityBill.value;
  void toggleGas() => gasBill.value = !gasBill.value;
  void toggleWater() => waterBill.value = !waterBill.value;

  Map<String, dynamic> get predictionInput {
    return {
      'property_type': propertyType.value,
      'city': city.value,
      'location': locationController.text.trim(),
      'province_name': provinceName.value,
      'purpose': purpose.value,
      'latitude': double.tryParse(latitudeController.text.trim()),
      'longitude': double.tryParse(longitudeController.text.trim()),
      'bedrooms': int.tryParse(bedrooms.value?.replaceAll('+', '') ?? ''),
      'baths': int.tryParse(bathrooms.value?.replaceAll('+', '') ?? ''),
      'area_sqft': double.tryParse(sizeController.text.trim()),
      'age_of_house': double.tryParse(ageOfHouseController.text.trim()),
    };
  }

  Future<void> predictPrice() async {
    if (isPredictingPrice.value || !_validatePredictionInput()) return;

    isPredictingPrice.value = true;
    try {
      pricePrediction.value = await PricePredictionService.predict(
        predictionInput,
      );
    } catch (error) {
      _showError(
        'Could not predict the price. Keep the model API running and try again. '
        '$error',
      );
    } finally {
      isPredictingPrice.value = false;
    }
  }

  void clearPricePrediction() {
    pricePrediction.value = null;
  }

  bool _validatePredictionInput() {
    if (provinceName.value == null ||
        city.value == null ||
        locationController.text.trim().isEmpty) {
      _showError('Complete the location step before predicting price');
      return false;
    }
    if (propertyType.value == null ||
        bedrooms.value == null ||
        bathrooms.value == null ||
        purpose.value == null ||
        sizeController.text.trim().isEmpty ||
        ageOfHouseController.text.trim().isEmpty) {
      _showError('Complete the property and pricing details first');
      return false;
    }
    if (latitudeController.text.trim().isEmpty ||
        longitudeController.text.trim().isEmpty) {
      _showError('Latitude and longitude are required for prediction');
      return false;
    }
    return true;
  }

  // Step 4: display features and images.
  final RxSet<String> selectedFeatures = <String>{}.obs;
  final descriptionController = TextEditingController();
  final RxList<File> selectedImages = <File>[].obs;

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
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      selectedImages.addAll(picked.map((image) => File(image.path)));
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImages.add(File(picked.path));
    }
  }

  void removeImageAt(int index) {
    if (index < 0 || index >= selectedImages.length) return;
    selectedImages.removeAt(index);
  }

  Future<void> submitForm() async {
    if (isSubmitting.value) return;
    if (pricePrediction.value == null) {
      _showError('Please calculate the AI predicted price before submitting');
      goToStep(2);
      return;
    }

    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      _showError('Please sign in before posting a property');
      return;
    }

    isSubmitting.value = true;
    try {
      await ProfileService.ensureCurrentProfile();
      final listings = Get.put(PropertyListingController(), permanent: true);
      final titleParts = [
        if (propertyType.value != null) propertyType.value!,
        if (purpose.value != null) purpose.value!,
      ];
      var imageUrls = <String>[];
      try {
        imageUrls = await PropertyService.uploadPropertyImages(selectedImages);
      } catch (error) {
        Get.snackbar(
          'Images not uploaded',
          'The property will be posted without photos. Supabase Storage says: $error',
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }

      await listings.addProperty(
        PostedProperty(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          ownerId: currentUser.id,
          ownerName: '',
          ownerPhone: '',
          title: titleParts.isEmpty ? 'New Property' : titleParts.join(' '),
          location: locationController.text.trim(),
          city: city.value ?? '',
          province: provinceName.value ?? '',
          tenantType: tenantType.value ?? '',
          propertyType: propertyType.value ?? '',
          bedrooms: bedrooms.value ?? '',
          bathrooms: bathrooms.value ?? '',
          availableFrom: availableFrom.value ?? '',
          balcony: balcony.value ?? '',
          floorNo: floorNo.value ?? '',
          areaSqft: sizeController.text.trim(),
          ageOfHouse: ageOfHouseController.text.trim(),
          price: priceController.text.trim(),
          predictedPrice: pricePrediction.value?.databaseValue,
          priceFor: priceFor.value ?? '',
          purpose: purpose.value ?? '',
          description: descriptionController.text.trim(),
          features: selectedFeatures.toList(),
          includedBills: [
            if (electricityBill.value) 'Electricity Bill',
            if (gasBill.value) 'Gas',
            if (waterBill.value) 'Water Bill',
          ],
          latitude: latitudeController.text.trim(),
          longitude: longitudeController.text.trim(),
          imageUrl: imageUrls.isEmpty ? null : imageUrls.first,
          imageUrls: imageUrls,
          imagePath: selectedImages.isEmpty ? null : selectedImages.first.path,
          imagePaths: selectedImages.map((image) => image.path).toList(),
        ),
      );

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

      if (Get.isRegistered<OnboardingController>()) {
        resetForm();
        Get.find<OnboardingController>().changePage(0);
      }
    } catch (error) {
      _showError('Could not post property: $error');
    } finally {
      isSubmitting.value = false;
    }
  }

  bool validateStep1() {
    if (tenantType.value == null) {
      _showError('Please select Property For');
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
    if (provinceName.value == null) {
      _showError('Please select Province');
      return false;
    }
    if (city.value == null) {
      _showError('Please select City');
      return false;
    }
    if (locationController.text.trim().isEmpty) {
      _showError('Please enter Location');
      return false;
    }
    if (latitudeController.text.trim().isEmpty) {
      _showError('Please enter Latitude');
      return false;
    }
    if (longitudeController.text.trim().isEmpty) {
      _showError('Please enter Longitude');
      return false;
    }
    return true;
  }

  bool validateStep3() {
    if (purpose.value == null) {
      _showError('Please select Purpose');
      return false;
    }
    if (sizeController.text.trim().isEmpty) {
      _showError('Please enter Area in Sq Ft');
      return false;
    }
    if (ageOfHouseController.text.trim().isEmpty) {
      _showError('Please enter Age of House');
      return false;
    }
    if (pricePrediction.value == null) {
      _showError('Please calculate the AI predicted price before continuing');
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
  void onInit() {
    super.onInit();
    _predictionResetWorkers.addAll([
      ever(propertyType, (_) => clearPricePrediction()),
      ever(bedrooms, (_) => clearPricePrediction()),
      ever(bathrooms, (_) => clearPricePrediction()),
      ever(provinceName, (_) => clearPricePrediction()),
      ever(city, (_) => clearPricePrediction()),
      ever(purpose, (_) => clearPricePrediction()),
    ]);
    for (final controller in [
      locationController,
      latitudeController,
      longitudeController,
      sizeController,
      ageOfHouseController,
    ]) {
      controller.addListener(clearPricePrediction);
    }
    loadLocationOptions();
  }

  @override
  void onClose() {
    for (final worker in _predictionResetWorkers) {
      worker.dispose();
    }
    for (final controller in [
      locationController,
      latitudeController,
      longitudeController,
      sizeController,
      ageOfHouseController,
    ]) {
      controller.removeListener(clearPricePrediction);
    }
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    sizeController.dispose();
    ageOfHouseController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
