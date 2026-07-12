import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/chat_header.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_bubble.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_empty_states.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_input.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.thread, required this.controller});

  final AppMessageThread thread;
  final MessageController controller;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final scrollController = ScrollController();
  int lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    lastMessageCount = widget.thread.messages.length;
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLatest());
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final messageCount = widget.thread.messages.length;
    final changedThread = oldWidget.thread.id != widget.thread.id;
    if (changedThread || messageCount != lastMessageCount) {
      lastMessageCount = messageCount;
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToLatest());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToLatest() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Column(
      children: [
        ChatHeader(thread: widget.thread, controller: widget.controller),
        Expanded(
          child: widget.thread.messages.isEmpty
              ? EmptyChat(thread: widget.thread, responsive: responsive)
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(responsive.pagePadding),
                  itemCount: widget.thread.messages.length,
                  itemBuilder: (context, index) {
                    final message = widget.thread.messages[index];
                    final isMine =
                        message.senderId == AuthService.currentUser?.id;
                    return MessageBubble(message: message, isMine: isMine);
                  },
                ),
        ),
        Obx(() {
          if (widget.controller.errorMessage.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
            child: Text(
              widget.controller.errorMessage.value,
              style: TextStyle(color: Colors.red.shade600),
            ),
          );
        }),
        MessageInput(controller: widget.controller),
      ],
    );
  }
}
