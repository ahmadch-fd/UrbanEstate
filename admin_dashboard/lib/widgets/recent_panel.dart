import 'package:admin_dashboard/models/admin_profile.dart';
import 'package:admin_dashboard/models/admin_property.dart';
import 'package:admin_dashboard/widgets/info_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentUsersPanel extends StatelessWidget {
  const RecentUsersPanel({super.key, required this.users});

  final List<AdminProfile> users;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      title: 'Recent Users',
      child: users.isEmpty
          ? const Text('No users yet')
          : Column(
              children: users.map((user) {
                return _RecentRow(
                  icon: Icons.person,
                  title: user.fullName.isEmpty ? user.email : user.fullName,
                  subtitle: _dateText(user.createdAt),
                  badge: user.role,
                );
              }).toList(),
            ),
    );
  }
}

class RecentPropertiesPanel extends StatelessWidget {
  const RecentPropertiesPanel({super.key, required this.properties});

  final List<AdminProperty> properties;

  @override
  Widget build(BuildContext context) {
    return InfoPanel(
      title: 'Recent Properties',
      child: properties.isEmpty
          ? const Text('No properties yet')
          : Column(
              children: properties.map((property) {
                return _RecentRow(
                  icon: Icons.home_work,
                  title: property.title,
                  subtitle: '${property.city}, ${property.province}',
                  badge: property.createdAt == null
                      ? property.purpose
                      : _dateText(property.createdAt),
                );
              }).toList(),
            ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEAF5EF),
            child: Icon(icon, color: const Color(0xFF004D40)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC6FF00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge.isEmpty ? '-' : badge,
              style: GoogleFonts.poppins(
                color: const Color(0xFF004D40),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _dateText(DateTime? date) {
  if (date == null) return 'No date';
  return '${date.day}/${date.month}/${date.year}';
}
