import 'dart:io';

import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';

class SelectedImagePreview extends StatelessWidget {
  const SelectedImagePreview({
    super.key,
    required this.imagePath,
    required this.onRemove,
  });

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.file(File(imagePath), fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Photo selected',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: AppColors.forestGreen),
          ),
        ],
      ),
    );
  }
}
