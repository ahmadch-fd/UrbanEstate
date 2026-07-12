import 'package:flutter/material.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/utils/app_colors.dart';

class MessageAvatar extends StatelessWidget {
  const MessageAvatar({super.key, required this.thread});

  final AppMessageThread thread;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = thread.contactAvatarUrl;

    return CircleAvatar(
      backgroundColor: AppColors.primaryLight,
      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
          ? NetworkImage(avatarUrl)
          : null,
      child: avatarUrl == null || avatarUrl.isEmpty
          ? const Icon(Icons.person, color: AppColors.forestGreen)
          : null,
    );
  }
}
