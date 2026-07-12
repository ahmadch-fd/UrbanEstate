import 'dart:math' as math;

import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartPanel extends StatelessWidget {
  const ChartPanel({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final buckets = data.lastSevenUserCounts;
    final maxCount = math.max(
      1,
      buckets.map((item) => item.count).fold(0, math.max),
    );
    final totalNewUsers = buckets.fold<int>(
      0,
      (total, bucket) => total + bucket.count,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'User Growth',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF004D40),
                  ),
                ),
                const Spacer(),
                _ChartBadge(label: '$totalNewUsers new this week'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Daily new user registrations for the last 7 days.',
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 310,
              child: BarChart(
                BarChartData(
                  maxY: maxCount.toDouble() + 2,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        const FlLine(color: Color(0xFFE2EAE6), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 11,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= buckets.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              buckets[index].label,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < buckets.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: buckets[i].count == 0
                                ? 0.12
                                : buckets[i].count.toDouble(),
                            color: const Color(0xFF004D40),
                            width: 34,
                            borderRadius: BorderRadius.circular(8),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxCount.toDouble() + 2,
                              color: const Color(0xFFF2F6F4),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBadge extends StatelessWidget {
  const _ChartBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC6FF00),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: const Color(0xFF004D40),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
