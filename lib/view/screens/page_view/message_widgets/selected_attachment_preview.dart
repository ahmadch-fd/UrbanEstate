import 'dart:io';

import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';

class SelectedAttachmentPreview extends StatelessWidget {
  const SelectedAttachmentPreview({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.isImage,
    required this.onRemove,
  });

  final String filePath;
  final String fileName;
  final bool isImage;
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
          _AttachmentThumb(filePath: filePath, isImage: isImage),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName.isEmpty ? 'File selected' : fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black87),
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

class _AttachmentThumb extends StatelessWidget {
  const _AttachmentThumb({required this.filePath, required this.isImage});

  final String filePath;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: isImage
          ? Image.file(File(filePath), fit: BoxFit.cover)
          : const Icon(
              Icons.insert_drive_file,
              color: AppColors.forestGreen,
              size: 34,
            ),
    );
  }
}
