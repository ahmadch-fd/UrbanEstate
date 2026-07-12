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
          CustomDropdownField<String>(
            hint: 'Purpose',
            value: controller.purpose.value,
            items: controller.purposeOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.purpose.value = val,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Area Sq Ft',
            controller: controller.sizeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Age of House (Years)',
            controller: controller.ageOfHouseController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _PredictionCard(controller: controller),
          const SizedBox(height: 20),
          const SectionLabel(text: 'Display Price (Optional)'),
          const SizedBox(height: 10),
          CustomTextField(
            hint: 'Manual Price Optional',
            controller: controller.priceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          CustomDropdownField<String>(
            hint: 'Price For (Display Only)',
            value: controller.priceFor.value,
            items: controller.priceForOptions,
            itemLabel: (e) => e,
            onChanged: (val) => controller.priceFor.value = val,
          ),
          const SizedBox(height: 20),
          const SectionLabel(text: 'Price Included With'),
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

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.controller});

  final PostPropertyController controller;

  @override
  Widget build(BuildContext context) {
    final prediction = controller.pricePrediction.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF004D40).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_graph, color: Color(0xFF004D40)),
              SizedBox(width: 8),
              Text(
                'AI Price Prediction',
                style: TextStyle(
                  color: Color(0xFF004D40),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (prediction != null) ...[
            const SizedBox(height: 12),
            Text(
              prediction.formattedValue,
              style: const TextStyle(
                color: Color(0xFF004D40),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'Estimated market price',
              style: TextStyle(color: Colors.black54),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: controller.isPredictingPrice.value
                  ? null
                  : controller.predictPrice,
              icon: controller.isPredictingPrice.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.calculate_outlined),
              label: Text(
                controller.isPredictingPrice.value
                    ? 'Predicting...'
                    : prediction == null
                    ? 'Predict Price'
                    : 'Predict Again',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF004D40),
                side: const BorderSide(color: Color(0xFF004D40)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
