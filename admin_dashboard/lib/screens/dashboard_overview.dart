import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/widgets/activity_panel.dart';
import 'package:admin_dashboard/widgets/breakdown_panel.dart';
import 'package:admin_dashboard/widgets/chart_panel.dart';
import 'package:admin_dashboard/widgets/metric_card.dart';
import 'package:admin_dashboard/widgets/recent_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Overview',
          style: GoogleFonts.poppins(
            color: const Color(0xFF004D40),
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Monitor users, listings, locations, and today activity.',
          style: GoogleFonts.poppins(color: Colors.black54),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            MetricCard(
              title: 'Total Users',
              value: data.profiles.length.toString(),
              subtitle: '+${data.todayUsers} today',
              icon: Icons.groups,
            ),
            MetricCard(
              title: 'Properties',
              value: data.properties.length.toString(),
              subtitle: '+${data.todayProperties} today',
              icon: Icons.home_work,
            ),
            MetricCard(
              title: 'Admins',
              value: data.profiles
                  .where((profile) => profile.isSuperAdmin)
                  .length
                  .toString(),
              subtitle: 'Superadmin users',
              icon: Icons.verified_user,
            ),
            MetricCard(
              title: 'Cities',
              value: data.properties
                  .map((property) => property.city)
                  .where((city) => city.isNotEmpty)
                  .toSet()
                  .length
                  .toString(),
              subtitle: 'With active posts',
              icon: Icons.location_city,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ChartPanel(data: data),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;
            final panels = [
              ActivityPanel(data: data),
              BreakdownPanel(
                title: 'Properties by Province',
                items: data.propertiesByProvince,
              ),
            ];

            if (!isWide) {
              return Column(
                children: panels
                    .map(
                      (panel) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: panel,
                      ),
                    )
                    .toList(),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < panels.length; i++) ...[
                  Expanded(child: panels[i]),
                  if (i != panels.length - 1) const SizedBox(width: 18),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;
            final panels = [
              RecentUsersPanel(users: data.recentProfiles),
              RecentPropertiesPanel(properties: data.recentProperties),
            ];

            if (!isWide) {
              return Column(
                children: panels
                    .map(
                      (panel) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: panel,
                      ),
                    )
                    .toList(),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < panels.length; i++) ...[
                  Expanded(child: panels[i]),
                  if (i != panels.length - 1) const SizedBox(width: 18),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
