import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/models/message_thread.dart';
import 'package:urban_estate/utils/responsive.dart';

class EmptyMessages extends StatelessWidget {
  const EmptyMessages({super.key, required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.pagePadding),
        child: Text(
          'Open a property and tap the chat button to start a conversation.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.black54),
        ),
      ),
    );
  }
}

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key, required this.thread, required this.responsive});

  final AppMessageThread thread;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.pagePadding),
        child: Text(
          'Message ${thread.contactName} about ${thread.propertyTitle}.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.black54),
        ),
      ),
    );
  }
}
