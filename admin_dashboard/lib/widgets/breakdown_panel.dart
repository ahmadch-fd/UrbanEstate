import 'package:admin_dashboard/widgets/info_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BreakdownPanel extends StatelessWidget {
  const BreakdownPanel({super.key, required this.title, required this.items});

  final String title;
  final Map<String, int> items;

  @override
  Widget build(BuildContext context) {
    final total = items.values.fold<int>(0, (sum, value) => sum + value);
    final entries = items.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return InfoPanel(
      title: title,
      child: entries.isEmpty
          ? const Text('No data yet')
          : Column(
              children: entries.take(6).map((entry) {
                final progress = total == 0 ? 0.0 : entry.value / total;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            entry.value.toString(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF004D40),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          minHeight: 9,
                          value: progress,
                          backgroundColor: const Color(0xFFEAF0ED),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF004D40),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
