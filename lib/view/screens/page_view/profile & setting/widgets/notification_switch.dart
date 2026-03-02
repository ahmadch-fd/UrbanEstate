import 'package:flutter/material.dart';

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({super.key});

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool _isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Switch(
          value: _isNotificationOn,
          onChanged: (bool value) {
            setState(() {
              _isNotificationOn = value;
            });
          },
          // Matching the UrbanEstate colors from your image
          activeThumbColor: const Color(0xFFF1F8E9), // Light cream thumb
          activeTrackColor: const Color(0xFF004D40), // Forest green track
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
        ),
      ],
    );
  }
}