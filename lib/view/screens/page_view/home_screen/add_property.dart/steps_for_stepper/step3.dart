import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_drop_down.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/input_field.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/selection_label.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/toggle_chip.dart';

class Step3Pricing extends StatelessWidget {
  final PostPropertyController controller;

  const Step3Pricing({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price
          CustomTextField(
            hint: 'Price',
            controller: controller.priceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Price For
          CustomDropdownField<String>(
            hint: 'Price For',
            value: controller.priceFor.value,
            items: controller.priceForOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.priceFor.value = val,
          ),
          const SizedBox(height: 20),

          // Price Included with
          const SectionLabel(text: 'Price Included with'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ToggleChip(
                label: 'Electricity Bill',
                icon: Icons.bolt,
                selected: controller.electricityBill.value,
                onTap: controller.toggleElectricity,
              ),
              ToggleChip(
                label: 'Gas',
                icon: Icons.local_fire_department,
                selected: controller.gasBill.value,
                onTap: controller.toggleGas,
              ),
              ToggleChip(
                label: 'Water Bill',
                icon: Icons.water_drop,
                selected: controller.waterBill.value,
                onTap: controller.toggleWater,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Next Button
           // I use this next button in add_property 
          PrimaryButton(
            label: 'Next',
            onTap: () {
              if (controller.validateStep3()) controller.nextStep();
            },
          ),
        ],
      ),
    );
  }
}
