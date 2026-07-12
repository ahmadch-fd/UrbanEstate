import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/message_widgets/message_avatar.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.thread, required this.controller});

  final AppMessageThread thread;
  final MessageController controller;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.closeThread,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          MessageAvatar(thread: thread),
          SizedBox(width: responsive.space(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thread.contactName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.font(15),
                  ),
                ),
                Text(
                  thread.propertyTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: responsive.font(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
