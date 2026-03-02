import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_const.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({super.key, required this.textcontroller});
  final TextEditingController textcontroller;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.88,
      child: TextFormField(
        cursorColor: Colors.grey,
        controller: textcontroller,
        decoration: InputDecoration(
          hint: Text('e.g. John Doe'),
          hintStyle: poppinsRegular.copyWith(fontSize: 12, color: Colors.grey),
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
      ),
    );
  }
}
