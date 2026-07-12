import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/message_attachment_controller.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/selected_attachment_preview.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.controller});

  final MessageController controller;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final textController = TextEditingController();
  late final MessageAttachmentController attachmentController;

  @override
  void initState() {
    super.initState();
    attachmentController = Get.put(MessageAttachmentController());
  }

  @override
  void dispose() {
    attachmentController.clearAttachment();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.pagePadding,
        responsive.space(8),
        responsive.pagePadding,
        responsive.bottomNavSpace,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final filePath = attachmentController.selectedFilePath.value;
            if (filePath.isEmpty) return const SizedBox.shrink();

            return SelectedAttachmentPreview(
              filePath: filePath,
              fileName: attachmentController.selectedFileName.value,
              isImage: attachmentController.isImageSelected,
              onRemove: attachmentController.clearAttachment,
            );
          }),
          Row(
            children: [
              IconButton(
                onPressed: () => _showAttachmentSheet(context),
                icon: const Icon(Icons.attach_file),
                color: AppColors.forestGreen,
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    filled: true,
                    fillColor: const Color(0xFFF4F6F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.space(10)),
              ObxSendButton(
                controller: widget.controller,
                onSend: () async {
                  final attachmentPath =
                      attachmentController.selectedFilePath.value;
                  await widget.controller.sendMessage(
                    textController.text,
                    attachmentPath: attachmentPath,
                    attachmentName: attachmentController.selectedFileName.value,
                  );
                  textController.clear();
                  attachmentController.clearAttachment();
                },
              ),
            ],
          ),
          Obx(() {
            if (attachmentController.errorMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                attachmentController.errorMessage.value,
                style: TextStyle(color: Colors.red.shade600, fontSize: 12),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.forestGreen,
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  attachmentController.pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: AppColors.forestGreen,
                ),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  attachmentController.pickDocument();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ObxSendButton extends StatelessWidget {
  const ObxSendButton({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final MessageController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.forestGreen,
          foregroundColor: Colors.white,
        ),
        onPressed: controller.isSending.value ? null : onSend,
        icon: controller.isSending.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.send),
      ),
    );
  }
}
