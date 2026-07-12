import 'package:admin_dashboard/controllers/dashboard_controller.dart';
import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/widgets/section_header.dart';
import 'package:flutter/material.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({
    super.key,
    required this.data,
    required this.controller,
  });

  final DashboardData data;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SectionHeader(title: 'Properties', count: data.properties.length),
        const SizedBox(height: 12),
        DataTable(
          columns: const [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Owner')),
            DataColumn(label: Text('City')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Actions')),
          ],
          rows: [
            for (final property in data.properties)
              DataRow(
                cells: [
                  DataCell(Text(property.title)),
                  DataCell(Text(property.ownerName)),
                  DataCell(Text(property.city)),
                  DataCell(Text(property.price.isEmpty ? '-' : property.price)),
                  DataCell(
                    IconButton(
                      onPressed: () => controller.deleteProperty(property.id),
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
