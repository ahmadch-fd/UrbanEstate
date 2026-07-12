import 'package:admin_dashboard/controllers/dashboard_controller.dart';
import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/widgets/section_header.dart';
import 'package:flutter/material.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({
    super.key,
    required this.data,
    required this.controller,
  });

  final DashboardData data;
  final DashboardController controller;

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _addLocation() async {
    final province = _provinceController.text.trim();
    final city = _cityController.text.trim();
    if (province.isEmpty || city.isEmpty) return;

    await widget.controller.addLocation(province: province, city: city);
    _provinceController.clear();
    _cityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SectionHeader(
          title: 'Pakistan Locations',
          count: widget.data.locations.length,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _provinceController,
                    decoration: const InputDecoration(
                      labelText: 'Province',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    onSubmitted: (_) => _addLocation(),
                  ),
                ),
                FilledButton.icon(
                  onPressed: _addLocation,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Location'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Province')),
              DataColumn(label: Text('City')),
              DataColumn(label: Text('Active')),
              DataColumn(label: Text('Actions')),
            ],
            rows: [
              for (final location in widget.data.locations)
                DataRow(
                  cells: [
                    DataCell(Text(location.province)),
                    DataCell(Text(location.city)),
                    DataCell(
                      Switch(
                        value: location.isActive,
                        onChanged: (value) => widget.controller
                            .setLocationActive(location.id, value),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () =>
                            widget.controller.deleteLocation(location.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
