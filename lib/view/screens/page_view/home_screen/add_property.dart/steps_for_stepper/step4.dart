import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/selection_label.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/toggle_chip.dart';

class Step4Features extends StatelessWidget {
  const Step4Features({super.key, required this.controller});

  final PostPropertyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SectionLabel(text: 'Description'),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'Write something about your property...',
            controller: controller.descriptionController,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          const SectionLabel(text: 'Pictures'),
          const SizedBox(height: 10),
          _ImagePickerSection(controller: controller),
          const SizedBox(height: 13),
          PrimaryButton(
            label: controller.isSubmitting.value ? 'Posting...' : 'Submit',
            onTap: () => controller.submitForm(),
          ),
        ],
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  const _ImagePickerSection({required this.controller});

  final PostPropertyController controller;

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
                'Add Property Pictures',
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
                title: const Text('Choose one or more from Gallery'),
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
      final images = controller.selectedImages;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final image = images[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(text: 'Picture ${index + 1}'),
                  const SizedBox(height: 8),
                  Stack(
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
                          onTap: () => controller.removeImageAt(index),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (images.isNotEmpty) const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showPickerOptions(context),
            child: Container(
              width: double.infinity,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    images.isEmpty
                        ? 'Add property pictures'
                        : 'Add more pictures',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
