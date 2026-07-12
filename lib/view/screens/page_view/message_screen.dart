import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/chat_view.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/conversation_list.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.threads.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeThread = controller.activeThread;
          if (activeThread != null) {
            return ChatView(thread: activeThread, controller: controller);
          }

          return ConversationList(controller: controller);
        }),
      ),
    );
  }
}
