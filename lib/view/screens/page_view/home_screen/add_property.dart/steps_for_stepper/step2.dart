import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_drop_down.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';

class Step2Location extends StatelessWidget {
  final PostPropertyController controller;

  const Step2Location({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdownField<String>(
            hint: 'Province Name',
            value: controller.provinceName.value,
            items: controller.provinceOptions,
            itemLabel: (e) => e,
            onChanged: controller.onProvinceChanged,
          ),
          const SizedBox(height: 12),
          CustomDropdownField<String>(
            hint: 'City',
            value: controller.city.value,
            items: controller.cityOptions,
            itemLabel: (e) => e,
            onChanged: controller.provinceName.value == null
                ? (_) {}
                : (val) => controller.city.value = val,
            enabled: controller.provinceName.value != null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Location / Area e.g. DHA Defence',
            controller: controller.locationController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Latitude e.g. 31.4805',
            controller: controller.latitudeController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Longitude e.g. 74.4124',
            controller: controller.longitudeController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Next',
            onTap: () {
              if (controller.validateStep2()) controller.nextStep();
            },
          ),
        ],
      ),
    );
  }
}
