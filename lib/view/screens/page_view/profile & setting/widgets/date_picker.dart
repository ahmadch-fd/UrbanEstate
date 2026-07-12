import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.88,
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          //hint: Text('e.g. John Doe'),
          // hintStyle: poppinsRegular.copyWith(fontSize: 12, color: Colors.grey),
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
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (pickedDate == null) return;

          controller.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        },
      ),
    );
  }
}
