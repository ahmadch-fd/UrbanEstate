import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/widgets/info_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityPanel extends StatelessWidget {
  const ActivityPanel({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      title: 'Today Activity',
      child: Column(
        children: [
          _ActivityRow(
            icon: Icons.person_add_alt_1,
            label: 'New users today',
            value: data.todayUsers.toString(),
          ),
          const Divider(height: 24),
          _ActivityRow(
            icon: Icons.add_home_work,
            label: 'New properties today',
            value: data.todayProperties.toString(),
          ),
          const Divider(height: 24),
          _ActivityRow(
            icon: Icons.sell,
            label: 'For sale posts',
            value: data.saleProperties.toString(),
          ),
          const Divider(height: 24),
          _ActivityRow(
            icon: Icons.key,
            label: 'For rent posts',
            value: data.rentProperties.toString(),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFEAF5EF),
          child: Icon(icon, color: const Color(0xFF004D40)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: const Color(0xFF004D40),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
