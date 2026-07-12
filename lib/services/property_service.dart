import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/models/posted_property.dart';

class PropertyService {
  PropertyService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static String? get currentUserId => _client.auth.currentUser?.id;

  static Future<List<PostedProperty>> fetchFeed() async {
    final response = await _client
        .from('properties')
        .select(
          '*, profiles!properties_owner_id_fkey(full_name, phone, avatar_url)',
        )
        .order('created_at', ascending: false);

    return response
        .map<PostedProperty>((item) => PostedProperty.fromMap(item))
        .toList();
  }

  static Future<PostedProperty> createProperty(PostedProperty property) async {
    late final Map<String, dynamic> response;

    try {
      response = await _client
          .from('properties')
          .insert(property.toInsertMap())
          .select(
            '*, profiles!properties_owner_id_fkey(full_name, phone, avatar_url)',
          )
          .single();
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST204' && error.message.contains('tenant_type')) {
        throw const PropertySetupException(
          'Please run the updated supabase_setup.sql file once. '
          'The properties table is missing the tenant_type column.',
        );
      }
      rethrow;
    }

    return PostedProperty.fromMap(response);
  }

  static Future<void> deleteProperty(String id) async {
    await _client.from('properties').delete().eq('id', id);
  }

  static Future<List<String>> fetchRecentlyViewedPropertyIds() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];

    try {
      final response = await _client
          .from('property_views')
          .select('property_id')
          .eq('user_id', user.id)
          .order('viewed_at', ascending: false)
          .limit(20);

      return response
          .map<String>((item) => (item['property_id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (error) {
      if (error.code == '42P01' || error.code == 'PGRST205') {
        return const [];
      }
      rethrow;
    }
  }

  static Future<void> markPropertyViewed(String propertyId) async {
    final user = _client.auth.currentUser;
    if (user == null || propertyId.isEmpty) return;

    try {
      await _client.from('property_views').upsert({
        'user_id': user.id,
        'property_id': propertyId,
        'viewed_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id,property_id');
    } on PostgrestException catch (error) {
      if (error.code == '42P01' || error.code == 'PGRST205') {
        return;
      }
      rethrow;
    }
  }

  static Future<String?> uploadPropertyImage(File? image) async {
    if (image == null) return null;

    final user = _client.auth.currentUser;
    if (user == null) return null;

    final extension = image.path.split('.').last;
    final path =
        '${user.id}/${DateTime.now().microsecondsSinceEpoch}.$extension';

    await _client.storage
        .from('property-images')
        .upload(path, image, fileOptions: const FileOptions(upsert: true));

    return _client.storage.from('property-images').getPublicUrl(path);
  }

  static Future<List<String>> uploadPropertyImages(List<File> images) async {
    final urls = <String>[];

    for (final image in images) {
      final url = await uploadPropertyImage(image);
      if (url != null && url.isNotEmpty) {
        urls.add(url);
      }
    }

    return urls;
  }
}

class PropertySetupException implements Exception {
  const PropertySetupException(this.message);

  final String message;

  @override
  String toString() => message;
}
