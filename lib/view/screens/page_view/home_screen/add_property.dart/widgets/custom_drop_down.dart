import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final safeItems = items.whereType<T>().toList();
    final safeValue = safeItems.contains(value) ? value : null;

    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          value: safeValue,
          isExpanded: true,
          hint: Text(
            hint,
            style: poppinsRegular.copyWith(
              color: enabled ? AppColors.hint : Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          style: poppinsRegular.copyWith(
            color: enabled ? AppColors.text : Colors.grey.shade400,
            fontSize: 14,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: enabled ? AppColors.hint : Colors.grey.shade300,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 8,
          ),
          menuItemStyleData: MenuItemStyleData(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return AppColors.forestGreen;
              }
              return null;
            }),
            selectedMenuItemBuilder: (context, child) =>
                ColoredBox(color: AppColors.forestGreen, child: child),
          ),
          selectedItemBuilder: (context) => safeItems
              .map(
                (item) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    itemLabel(item),
                    overflow: TextOverflow.ellipsis,
                    style: poppinsRegular.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: enabled ? AppColors.text : Colors.grey.shade400,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          items: safeItems
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: _DropdownItemLabel(
                    label: itemLabel(item),
                    isSelected: item == safeValue,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DropdownItemLabel extends StatefulWidget {
  final String label;
  final bool isSelected;

  const _DropdownItemLabel({required this.label, required this.isSelected});

  @override
  State<_DropdownItemLabel> createState() => _DropdownItemLabelState();
}

class _DropdownItemLabelState extends State<_DropdownItemLabel> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Text(
        widget.label,
        overflow: TextOverflow.ellipsis,
        style: poppinsRegular.copyWith(
          fontSize: 14,
          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? Colors.white : AppColors.text,
        ),
      ),
    );
  }
}
