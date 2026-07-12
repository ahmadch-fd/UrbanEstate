import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static SupabaseClient get _client {
    if (!Supabase.instance.isInitialized) {
      throw StateError('Supabase is not initialized yet.');
    }
    return Supabase.instance.client;
  }

  static User? get currentUser => _client.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<AuthResponse> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim(), 'phone': phone.trim()},
    );
  }

  static Future<void> signOut() {
    return _client.auth.signOut();
  }
}
