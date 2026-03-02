import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/selection_label.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/toggle_chip.dart';

class Step4Features extends StatelessWidget {
  final PostPropertyController controller;

  const Step4Features({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Features
          Row(
            children: [
              const Icon(
                Icons.auto_fix_high,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              const SectionLabel(text: 'Feature'),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.featureOptions
                .map(
                  (feature) => ToggleChip(
                    label: feature['label'] as String,
                    icon: feature['icon'] as IconData,
                    selected: controller.selectedFeatures.contains(
                      feature['label'],
                    ),
                    onTap: () =>
                        controller.toggleFeature(feature['label'] as String),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // ── Description ──────────────────────────────────────
          const SectionLabel(text: 'Description'),
          const SizedBox(height: 10),

          CustomTextField(
            hint: 'Write something about your property...',
            controller: controller.descriptionController,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
                   
          // ── Picture ──────────────────────────────────────────
          const SectionLabel(text: 'Picture 1'),
          const SizedBox(height: 10),

          _ImagePickerSection(controller: controller),

          const SizedBox(height: 10),
          const SectionLabel(text: 'Picture 2'),
          const SizedBox(height: 10),
          _ImagePickerSection(controller: controller),
          const SizedBox(height: 10), const SectionLabel(text: 'Picture 3'),
          const SizedBox(height: 10),
          _ImagePickerSection(controller: controller),
          const SizedBox(height: 10), const SectionLabel(text: 'Picture 4'),
          const SizedBox(height: 10),
          _ImagePickerSection(controller: controller),
          const SizedBox(height: 13),
          // ── Submit Button
          PrimaryButton(label: 'Submit', onTap: controller.submitForm),
        ],
      ),
    );
  }
}

// Image Picker Section

class _ImagePickerSection extends StatelessWidget {
  final PostPropertyController controller;

  const _ImagePickerSection({required this.controller});

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  controller.pickImage();
                },
              ),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Get.back();
                  controller.pickImageFromCamera();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final image = controller.selectedImage.value;

      if (image != null) {
        // Show selected image preview
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: controller.removeImage,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _showPickerOptions(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Change',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }

      // Empty state — tap to pick
      return GestureDetector(
        onTap: () => _showPickerOptions(context),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 32),
            ],
          ),
        ),
      );
    });
  }
}
