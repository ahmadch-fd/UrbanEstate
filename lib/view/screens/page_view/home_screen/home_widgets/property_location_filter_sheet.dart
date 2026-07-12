import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/responsive.dart';

Future<void> showPropertyLocationFilterSheet({
  required BuildContext context,
  required PropertyListingController controller,
  required Responsive responsive,
}) {
  String? selectedProvince = controller.selectedProvince.value;
  String? selectedCity = controller.selectedCity.value;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final cityOptions = controller.citiesForProvince(selectedProvince);

          if (selectedCity != null && !cityOptions.contains(selectedCity)) {
            selectedCity = null;
          }

          return Padding(
            padding: EdgeInsets.only(
              left: responsive.pagePadding,
              right: responsive.pagePadding,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  responsive.space(18),
            ),
            child: Container(
              padding: EdgeInsets.all(responsive.space(18)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: responsive.icon(42),
                        width: responsive.icon(42),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: AppColors.mainTextColor,
                          size: responsive.icon(24),
                        ),
                      ),
                      SizedBox(width: responsive.space(12)),
                      Expanded(
                        child: Text(
                          'Filter Properties',
                          style: GoogleFonts.poppins(
                            color: AppColors.mainTextColor,
                            fontSize: responsive.font(18),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.space(18)),
                  _FilterDropdown(
                    label: 'Province',
                    hint: 'Select province',
                    value: selectedProvince,
                    items: controller.provinceOptions,
                    responsive: responsive,
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value;
                        selectedCity = null;
                      });
                    },
                  ),
                  SizedBox(height: responsive.space(14)),
                  _FilterDropdown(
                    label: 'City',
                    hint: selectedProvince == null
                        ? 'Select province first'
                        : 'Select city',
                    value: selectedCity,
                    items: cityOptions,
                    responsive: responsive,
                    onChanged: selectedProvince == null
                        ? null
                        : (value) => setState(() => selectedCity = value),
                  ),
                  SizedBox(height: responsive.space(20)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearLocationFilter();
                            Get.back<void>();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(responsive.scale(48)),
                            side: BorderSide(
                              color: AppColors.mainTextColor.withValues(
                                alpha: 0.28,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Clear',
                            style: GoogleFonts.poppins(
                              color: AppColors.mainTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.space(12)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedProvince == null
                              ? null
                              : () {
                                  controller.applyLocationFilter(
                                    province: selectedProvince,
                                    city: selectedCity,
                                  );
                                  Get.back<void>();
                                },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(responsive.scale(48)),
                            backgroundColor: const Color(0xFFC6FF00),
                            foregroundColor: AppColors.mainTextColor,
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor: Colors.grey,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.responsive,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final Responsive responsive;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.mainTextColor,
            fontSize: responsive.font(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: responsive.space(8)),
        DropdownButtonFormField<String>(
          key: ValueKey('$label-$value-${items.length}'),
          initialValue: value,
          isExpanded: true,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F6F4),
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.space(14),
              vertical: responsive.space(14),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.poppins(
            color: AppColors.mainTextColor,
            fontSize: responsive.font(14),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
