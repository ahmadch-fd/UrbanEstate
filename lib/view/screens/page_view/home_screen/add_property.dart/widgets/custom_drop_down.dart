import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(focusColor: AppColors.forestGreen),
          child: DropdownButton<T>(
            dropdownColor: Colors.white,
            //  focusColor: AppColors.forestGreen,
            value: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                color: enabled ? AppColors.hint : Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: enabled ? AppColors.hint : Colors.grey.shade300,
            ),
            style: TextStyle(
              color: enabled
                  ? const Color.fromARGB(255, 181, 113, 113)
                  : Colors.grey.shade400,
              fontSize: 14,
            ),
            onChanged: enabled ? onChanged : null,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      style: poppinsRegular.copyWith(
                        fontSize: 14,
                        color: item == value
                            ? const Color.fromARGB(255, 1, 0, 0)
                            : const Color.fromARGB(255, 133, 62, 62),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
