import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/categories_list_view.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/filtered_property_results.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/home_default_sections.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/home_header.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/property_location_filter_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final listingController = Get.put(
      PropertyListingController(),
      permanent: true,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.forestGreen,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              HomeHeader(
                responsive: responsive,
                onFilterTap: () => showPropertyLocationFilterSheet(
                  context: context,
                  controller: listingController,
                  responsive: responsive,
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => listingController.hasActiveFilter
                      ? _ActiveFilterBar(
                          controller: listingController,
                          responsive: responsive,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: responsive.sectionGap),
              ),
              SliverToBoxAdapter(child: CategorySelector()),
              SliverToBoxAdapter(
                child: SizedBox(height: responsive.sectionGap),
              ),
              Obx(() {
                final hasFilter = listingController.hasActiveFilter;
                final filteredProperties = listingController.filteredProperties;

                if (hasFilter) {
                  return FilteredPropertyResults(
                    title: listingController.activeFilterTitle,
                    properties: filteredProperties,
                    responsive: responsive,
                  );
                }

                return HomeDefaultSections(
                  properties: filteredProperties,
                  responsive: responsive,
                );
              }),
              SliverToBoxAdapter(
                child: SizedBox(height: responsive.bottomNavSpace),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({required this.controller, required this.responsive});

  final PropertyListingController controller;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (controller.selectedTenantType.value.isNotEmpty)
        _FilterChip(
          label: controller.selectedTenantType.value,
          onDeleted: controller.clearTenantTypeFilter,
        ),
      if (controller.locationFilterLabel.isNotEmpty)
        _FilterChip(
          label: controller.locationFilterLabel,
          onDeleted: controller.clearLocationFilter,
        ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.pagePadding,
        responsive.space(12),
        responsive.pagePadding,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: responsive.space(8),
              runSpacing: responsive.space(8),
              children: chips,
            ),
          ),
          TextButton(
            onPressed: controller.clearAllFilters,
            child: Text(
              'Clear all',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: const Color(0xFFC6FF00),
      labelStyle: TextStyle(
        color: AppColors.mainTextColor,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    );
  }
}
