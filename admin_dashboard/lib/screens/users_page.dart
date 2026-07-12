import 'package:admin_dashboard/controllers/dashboard_controller.dart';
import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/services/admin_service.dart';
import 'package:admin_dashboard/widgets/section_header.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key, required this.data, required this.controller});

  final DashboardData data;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SectionHeader(title: 'Users', count: data.profiles.length),
        const SizedBox(height: 12),
        DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Actions')),
          ],
          rows: [
            for (final profile in data.profiles)
              DataRow(
                cells: [
                  DataCell(
                    Text(profile.fullName.isEmpty ? '-' : profile.fullName),
                  ),
                  DataCell(Text(profile.email)),
                  DataCell(Text(profile.phone.isEmpty ? '-' : profile.phone)),
                  DataCell(Text(profile.role)),
                  DataCell(
                    IconButton(
                      onPressed: profile.id == AdminService.currentUserId
                          ? null
                          : () => controller.deleteProfile(profile.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
