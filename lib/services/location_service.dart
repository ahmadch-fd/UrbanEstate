import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  LocationService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static const Map<String, List<String>> fallbackProvinceCities = {
    'Punjab': [
      'Lahore',
      'Rawalpindi',
      'Faisalabad',
      'Bahawalpur',
      'Multan',
      'Gujranwala',
      'Sialkot',
    ],
    'Sindh': ['Karachi', 'Hyderabad', 'Sukkur'],
    'KPK': ['Peshawar', 'Abbottabad', 'Swat'],
    'Balochistan': ['Quetta', 'Gwadar'],
    'Islamabad Capital Territory': ['Islamabad'],
    'Azad Kashmir': ['Muzaffarabad', 'Mirpur'],
    'Gilgit-Baltistan': ['Gilgit', 'Skardu'],
  };

  static Future<Map<String, List<String>>> provinceCities() async {
    try {
      final response = await _client
          .from('pakistan_locations')
          .select('province, city')
          .eq('is_active', true)
          .order('province')
          .order('city');

      final locations = <String, List<String>>{};
      for (final item in response) {
        final province = item['province']?.toString().trim() ?? '';
        final city = item['city']?.toString().trim() ?? '';
        if (province.isEmpty || city.isEmpty) continue;
        locations.putIfAbsent(province, () => <String>[]);
        if (!locations[province]!.contains(city)) {
          locations[province]!.add(city);
        }
      }

      return locations.isEmpty ? fallbackProvinceCities : locations;
    } on PostgrestException catch (error) {
      if (error.code == '42P01' || error.code == 'PGRST205') {
        return fallbackProvinceCities;
      }
      rethrow;
    }
  }
}
