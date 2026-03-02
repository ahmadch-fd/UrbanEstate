import 'package:flutter/material.dart';

class CustomCircularAvatar extends StatelessWidget {
  const CustomCircularAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return CircleAvatar(
      radius: height * 0.05,
      backgroundColor: Colors.grey,
      child: Icon(Icons.arrow_back_ios),
    );
  }
}
