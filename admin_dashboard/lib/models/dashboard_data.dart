import 'package:admin_dashboard/models/admin_profile.dart';
import 'package:admin_dashboard/models/admin_property.dart';
import 'package:admin_dashboard/models/admin_location.dart';
import 'package:admin_dashboard/models/day_count.dart';

class DashboardData {
  DashboardData({
    required this.profiles,
    required this.properties,
    List<AdminLocation>? locations,
  }) : _locations = locations;

  final List<AdminProfile> profiles;
  final List<AdminProperty> properties;
  final List<AdminLocation>? _locations;

  List<AdminLocation> get locations => _locations ?? const [];

  int get todayUsers =>
      profiles.where((profile) => _isToday(profile.createdAt)).length;

  int get todayProperties =>
      properties.where((property) => _isToday(property.createdAt)).length;

  int get rentProperties =>
      properties.where((property) => property.purpose == 'For Rent').length;

  int get saleProperties =>
      properties.where((property) => property.purpose == 'For Sale').length;

  List<AdminProfile> get recentProfiles => profiles.take(5).toList();

  List<AdminProperty> get recentProperties => properties.take(5).toList();

  Map<String, int> get propertiesByProvince {
    final counts = <String, int>{};
    for (final property in properties) {
      final province = property.province.trim().isEmpty
          ? 'Unknown'
          : property.province.trim();
      counts[province] = (counts[province] ?? 0) + 1;
    }
    return counts;
  }

  List<DayCount> get lastSevenUserCounts {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index));
      final nextDay = day.add(const Duration(days: 1));
      final count = profiles.where((profile) {
        final createdAt = profile.createdAt;
        if (createdAt == null) return false;
        return !createdAt.isBefore(day) && createdAt.isBefore(nextDay);
      }).length;

      return DayCount('${day.day}/${day.month}', count);
    });
  }

  static bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
