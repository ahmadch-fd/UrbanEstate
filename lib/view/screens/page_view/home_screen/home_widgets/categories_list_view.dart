import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  // Track the selected category
  String selectedCategory = 'Family';

  final List<String> categories = [
    'Bachelor',
    'Family',
    'Office',
    'Sublet',
    'Flat',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          bool isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              // Styling based on your image
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF004D40) : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              selectedColor: const Color(0xFFC6FF00), // Lime green highlight
              backgroundColor: AppColors.forestGreen,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.white38,
                  width: 1,
                ),
              ),
              showCheckmark: false, // Removes the default check icon
              elevation: 0,
              pressElevation: 0,
            ),
          );
        }).toList(),
      ),
    );
  }
}
