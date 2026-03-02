import 'package:flutter/material.dart';

class PropertySectionLabel extends StatelessWidget {
  final String title;

  const PropertySectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D6A4F),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}