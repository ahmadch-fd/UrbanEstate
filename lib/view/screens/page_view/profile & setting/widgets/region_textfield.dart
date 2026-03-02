import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:urban_estate/utils/city_list.dart';

class RegionTextfield extends StatefulWidget {
  const RegionTextfield({super.key});

  @override
  State<RegionTextfield> createState() => _RegionTextfieldState();
}

class _RegionTextfieldState extends State<RegionTextfield> {
  String selectedCity = "Lahore, Punjab";

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.88,
      child: DropdownButtonFormField2<String>(
        value: selectedCity,
        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          scrollbarTheme: const ScrollbarThemeData(
            thumbVisibility: WidgetStatePropertyAll(true),
          ),
        ),

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 216, 216, 216),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 216, 216, 216),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),

        //  icon: const Icon(Icons.keyboard_arrow_down),
        items: cities.map((city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(
              city,
              style: poppinsRegular.copyWith(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),

        onChanged: (value) {
          setState(() {
            selectedCity = value!;
          });
        },
      ),
    );
  }
}
