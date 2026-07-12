import 'package:admin_dashboard/models/admin_location.dart';
import 'package:admin_dashboard/models/admin_profile.dart';
import 'package:admin_dashboard/models/admin_property.dart';
import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  AdminService._();

  static SupabaseClient get _client => Supabase.instance.client;
  static String? get currentUserId => _client.auth.currentUser?.id;

  static Future<AdminProfile?> currentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    final profile = AdminProfile.fromMap(response);
    return profile.email.isEmpty
        ? profile.copyWith(email: user.email ?? '')
        : profile;
  }

  static Future<DashboardData> dashboardData() async {
    final profilesResponse = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    final propertiesResponse = await _client
        .from('properties')
        .select(
          '*, profiles!properties_owner_id_fkey(full_name, phone, avatar_url)',
        )
        .order('created_at', ascending: false);
    final locations = await fetchLocations();

    return DashboardData(
      profiles: profilesResponse
          .map<AdminProfile>((item) => AdminProfile.fromMap(item))
          .toList(),
      properties: propertiesResponse
          .map<AdminProperty>((item) => AdminProperty.fromMap(item))
          .toList(),
      locations: locations,
    );
  }

  static Future<List<AdminLocation>> fetchLocations() async {
    try {
      final response = await _client
          .from('pakistan_locations')
          .select()
          .order('province')
          .order('city');

      return response
          .map<AdminLocation>((item) => AdminLocation.fromMap(item))
          .toList();
    } on PostgrestException catch (error) {
      if (error.code == '42P01' || error.code == 'PGRST205') {
        return const [];
      }
      rethrow;
    }
  }

  static Future<void> deleteProfile(String id) {
    return _client.from('profiles').delete().eq('id', id);
  }

  static Future<void> deleteProperty(String id) {
    return _client.from('properties').delete().eq('id', id);
  }

  static Future<void> addLocation({
    required String province,
    required String city,
  }) {
    return _client.from('pakistan_locations').upsert({
      'province': province.trim(),
      'city': city.trim(),
      'is_active': true,
    }, onConflict: 'province,city');
  }

  static Future<void> setLocationActive(String id, bool isActive) {
    return _client
        .from('pakistan_locations')
        .update({'is_active': isActive})
        .eq('id', id);
  }

  static Future<void> deleteLocation(String id) {
    return _client.from('pakistan_locations').delete().eq('id', id);
  }
}
