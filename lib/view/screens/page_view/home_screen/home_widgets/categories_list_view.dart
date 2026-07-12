import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late final PropertyListingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<PropertyListingController>()
        ? Get.find<PropertyListingController>()
        : Get.put(PropertyListingController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: controller.tenantTypeOptions.map((category) {
            final isSelected = controller.selectedTenantType.value == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    controller.setTenantTypeFilter(category);
                  });
                },
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF004D40) : Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                selectedColor: const Color(0xFFC6FF00),
                backgroundColor: AppColors.forestGreen,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : Colors.white38,
                    width: 1,
                  ),
                ),
                showCheckmark: false,
                elevation: 0,
                pressElevation: 0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
