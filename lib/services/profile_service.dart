import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/models/app_profile.dart';

class ProfileService {
  ProfileService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<AppProfile?> currentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return AppProfile.fromMap(response).withAuthEmailFallback(user.email);
  }

  static Future<void> upsertCurrentProfile({
    required String fullName,
    required String email,
    required String phone,
    String location = '',
    String dateOfBirth = '',
    String? avatarUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'location': location.trim(),
      'date_of_birth': dateOfBirth.trim(),
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> updateCurrentProfile({
    required String fullName,
    required String phone,
    required String location,
    required String dateOfBirth,
    File? avatarImage,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final avatarUrl = await uploadProfileImage(avatarImage);

    await _client
        .from('profiles')
        .update({
          'full_name': fullName.trim(),
          'phone': phone.trim(),
          'location': location.trim(),
          'date_of_birth': dateOfBirth.trim(),
          if (avatarUrl != null && avatarUrl.isNotEmpty)
            'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);
  }

  static Future<String?> uploadProfileImage(File? image) async {
    if (image == null) return null;

    final user = _client.auth.currentUser;
    if (user == null) return null;

    final extension = image.path.split('.').last;
    final path =
        '${user.id}/${DateTime.now().microsecondsSinceEpoch}.$extension';

    await _client.storage
        .from('profile-images')
        .upload(path, image, fileOptions: const FileOptions(upsert: true));

    return _client.storage.from('profile-images').getPublicUrl(path);
  }

  static Future<void> updateCurrentProfileImage(File image) async {
    final avatarUrl = await uploadProfileImage(image);
    final user = _client.auth.currentUser;

    if (user == null || avatarUrl == null || avatarUrl.isEmpty) return;

    await _client
        .from('profiles')
        .update({
          'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);
  }

  static Future<void> ensureCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata ?? const <String, dynamic>{};
    await _client.from('profiles').upsert({
      'id': user.id,
      'full_name': metadata['name']?.toString() ?? '',
      'email': user.email ?? '',
      'phone': metadata['phone']?.toString() ?? '',
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<AppProfile>> allProfiles() async {
    final response = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    return response
        .map<AppProfile>((item) => AppProfile.fromMap(item))
        .toList();
  }

  static Future<void> deleteProfile(String id) async {
    await _client.from('profiles').delete().eq('id', id);
  }
}
