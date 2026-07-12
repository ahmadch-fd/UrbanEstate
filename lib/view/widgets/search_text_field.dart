import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/responsive.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return SizedBox(
      height: responsive.searchHeight,
      child: TextFormField(
        cursorColor: AppColors.mainTextColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.white), // border when typing
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(040),

            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: AppColors.mainTextColor,
            fontSize: responsive.font(15),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: AppColors.mainTextColor,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(36)),
        ),
      ),
    );
  }
}
