import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_drop_down.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';

class Step1PropertyDetails extends StatelessWidget {
  final PostPropertyController controller;

  const Step1PropertyDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available From
          CustomDropdownField<String>(
            hint: 'Available From',
            value: controller.availableFrom.value,
            items: controller.availableFromOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.availableFrom.value = val,
          ),
          const SizedBox(height: 12),

          // Type of Property
          CustomDropdownField<String>(
            hint: 'Type of Property',
            value: controller.propertyType.value,
            items: controller.propertyTypeOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.propertyType.value = val,
          ),
          const SizedBox(height: 12),

          // Bedrooms
          CustomDropdownField<String>(
            hint: 'Bedrooms',
            value: controller.bedrooms.value,
            items: controller.bedroomOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.bedrooms.value = val,
          ),
          const SizedBox(height: 12),

          // Bathrooms
          CustomDropdownField<String>(
            hint: 'Bathrooms',
            value: controller.bathrooms.value,
            items: controller.bathroomOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.bathrooms.value = val,
          ),
          const SizedBox(height: 12),

          // Balcony
          CustomDropdownField<String>(
            hint: 'Balcony',
            value: controller.balcony.value,
            items: controller.balconyOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.balcony.value = val,
          ),
          const SizedBox(height: 12),

          // Floor No
          CustomDropdownField<String>(
            hint: 'Floor No',
            value: controller.floorNo.value,
            items: controller.floorOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.floorNo.value = val,
          ),
          const SizedBox(height: 12),

          // Size – Optional
          CustomTextField(
            hint: 'Size Optional',
            controller: controller.sizeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          // I use this next button in add_property
          //  Next Button
          PrimaryButton(
            label: 'Next',
            onTap: () {
              if (controller.validateStep1()) controller.nextStep();
            },
          ),
        ],
      ),
    );
  }
}
