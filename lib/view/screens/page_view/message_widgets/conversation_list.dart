import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_avatar.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_empty_states.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({super.key, required this.controller});

  final MessageController controller;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(responsive.pagePadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Messages',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: responsive.font(22),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.loadThreads,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        if (controller.errorMessage.value.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(color: Colors.red.shade600),
            ),
          ),
        Expanded(
          child: controller.threads.isEmpty
              ? EmptyMessages(responsive: responsive)
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    responsive.pagePadding,
                    0,
                    responsive.pagePadding,
                    responsive.bottomNavSpace,
                  ),
                  itemCount: controller.threads.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final thread = controller.threads[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: MessageAvatar(thread: thread),
                      title: Text(
                        thread.contactName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        thread.previewText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => controller.openThread(thread.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
