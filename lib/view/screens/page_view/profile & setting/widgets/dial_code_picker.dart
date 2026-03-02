import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:urban_estate/controllers/phone_picker_controller.dart';
import 'package:urban_estate/utils/app_const.dart';

class DialCodePicker extends StatefulWidget {
  const DialCodePicker({super.key});

  @override
  State<DialCodePicker> createState() => _DialCodePickerState();
}

class _DialCodePickerState extends State<DialCodePicker> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PhonePickerController controller = Get.put(PhonePickerController());
    // PhonePickerController(),
    // permanent: true,
   // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print("hi");
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            //  height: height * 0.01,
            width: width * 0.88,
            child: IntlPhoneField(
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              languageCode: "en",
              onChanged: (phone) {
                controller.phoneNumber.value = phone.completeNumber;
                print(phone.completeNumber);
              },
              onCountryChanged: (country) {
                controller.countryCode.value = country.name;
                print('Country changed to: ' + country.name);
              },
            ),
          ),
          // SizedBox(height: 10),
          // MaterialButton(
          //   child: Text('Submit'),
          //   color: Theme.of(context).primaryColor,
          //   textColor: Colors.white,
          //   onPressed: () {
          //     _formKey.currentState?.validate();
          //   },
          // ),
        ],
      ),
    );
  }
}
