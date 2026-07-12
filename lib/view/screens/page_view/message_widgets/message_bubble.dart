import 'package:flutter/material.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isMine});

  final AppChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: message.hasAttachment
            ? const EdgeInsets.all(6)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.forestGreen : const Color(0xFFF1F3F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.hasAttachment && message.isImageAttachment)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 220,
                  height: 180,
                  child: Image.network(
                    message.attachmentUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.broken_image,
                        color: isMine ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            if (message.isFileAttachment)
              _FileAttachmentTile(message: message, isMine: isMine),
            if (message.hasAttachment && message.text.isNotEmpty)
              const SizedBox(height: 8),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(color: isMine ? Colors.white : Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}

class _FileAttachmentTile extends StatelessWidget {
  const _FileAttachmentTile({required this.message, required this.isMine});

  final AppChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final textColor = isMine ? Colors.white : Colors.black87;
    final iconColor = isMine ? Colors.white : AppColors.forestGreen;

    return InkWell(
      onTap: () => launchUrl(
        Uri.parse(message.attachmentUrl!),
        mode: LaunchMode.externalApplication,
      ),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 220,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file, color: iconColor, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message.attachmentName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
