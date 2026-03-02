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
          // Division
          CustomDropdownField<String>(
            hint: 'Division',
            value: controller.division.value,
            items: controller.divisionOptions,
            itemLabel: (e) => e,
            onChanged: controller.onDivisionChanged,
          ),
          const SizedBox(height: 12),

          // District (enabled only when division is selected)
          CustomDropdownField<String>(
            hint: 'District',
            value: controller.district.value,
            items: controller.division.value != null
                ? ['Dhaka', 'Gazipur', 'Narayanganj', 'Narsingdi']
                : controller.districtOptions,
            itemLabel: (e) => e,
            onChanged: controller.division.value != null
                ? controller.onDistrictChanged
                : (_) {},
            enabled: controller.division.value != null,
          ),
          const SizedBox(height: 12),

          // Area (enabled only when district is selected)
          CustomDropdownField<String>(
            hint: 'Area',
            value: controller.area.value,
            items: controller.district.value != null
                ? ['Gulshan', 'Banani', 'Dhanmondi', 'Mirpur', 'Uttara']
                : controller.areaOptions,
            itemLabel: (e) => e,
            onChanged: (val) {
              if (controller.district.value != null) {
                controller.area.value = val;
              }
            },
            enabled: controller.district.value != null,
          ),
          const SizedBox(height: 32),

          // Sector No
          CustomTextField(
            hint: 'Sector No',
            controller: controller.sectorController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Road No
          CustomTextField(
            hint: 'Road No',
            controller: controller.roadController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // House No
          CustomTextField(
            hint: 'House No',
            controller: controller.houseNoController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // House Name
          CustomTextField(
            hint: 'House Name',
            controller: controller.houseNameController,
          ),
          const SizedBox(height: 24),

          // Next Button
           // I use this next button in add_property 
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
