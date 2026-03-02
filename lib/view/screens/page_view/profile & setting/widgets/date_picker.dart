import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/date_picker_controller.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    final DatePickerController datepickercontroller =
        Get.put<DatePickerController>(DatePickerController());
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.88,
      child: TextField(
        controller: dateController,
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

          if (pickedDate != null) {
            datepickercontroller.selectedDate.value = dateController.toString();
            dateController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          }
        },
      ),
    );
  }
}
