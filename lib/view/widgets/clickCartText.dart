import 'package:flutter/material.dart';

class Clickcarttext extends StatelessWidget {
  const Clickcarttext({super.key, required this.fontSize});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Urban',
            style: TextStyle(
              color: const Color.fromARGB(255, 40, 120, 56),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'Estate',
            style: TextStyle(
              color: Color.fromARGB(255, 182, 229, 7),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
