import 'package:admin_dashboard/services/admin_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAuthController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool isChecking = true;
  bool isAllowed = false;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> checkSession() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      isChecking = false;
      isAllowed = false;
      notifyListeners();
      return;
    }

    final profile = await AdminService.currentProfile();
    final allowed = profile?.isSuperAdmin ?? false;

    if (!allowed) {
      await _client.auth.signOut();
    }

    isChecking = false;
    isAllowed = allowed;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final profile = await AdminService.currentProfile();
      if (profile?.isSuperAdmin != true) {
        await _client.auth.signOut();
        errorMessage = 'Access denied. Superadmin only.';
        return;
      }

      isAllowed = true;
    } on AuthException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Unable to sign in. Please try again.';
    } finally {
      isLoading = false;
      isChecking = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    isAllowed = false;
    notifyListeners();
  }
}
