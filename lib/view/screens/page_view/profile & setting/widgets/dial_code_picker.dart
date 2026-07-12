import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class DialCodePicker extends StatefulWidget {
  const DialCodePicker({super.key, this.initialPhone = '', this.onChanged});

  final String initialPhone;
  final ValueChanged<String>? onChanged;

  @override
  State<DialCodePicker> createState() => _DialCodePickerState();
}

class _DialCodePickerState extends State<DialCodePicker> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            //  height: height * 0.01,
            width: width * 0.88,
            child: IntlPhoneField(
              initialValue: widget.initialPhone,
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
                widget.onChanged?.call(phone.completeNumber);
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
