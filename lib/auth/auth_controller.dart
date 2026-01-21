import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  AuthController._();
  static final AuthController instance = AuthController._();

  final SupabaseClient _client = Supabase.instance.client;

  /// =======================
  /// SIGN UP
  /// =======================
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    int role = 3, // 3 = Employee (default)
  }) async {
    try {
      final authResponse = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        return 'Signup failed';
      }

      // 🔑 Insert user profile
      final insertResponse = await _client.from('users').insert({
        'id': user.id, // MUST match auth.uid()
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
      });

      if (insertResponse.error != null) {
        return insertResponse.error!.message;
      }

      return null; // SUCCESS
    } catch (e) {
      return e.toString();
    }
  }

  /// =======================
  /// LOGIN
  /// =======================
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user == null) {
        return 'Login failed';
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// =======================
  /// LOGOUT
  /// =======================
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// =======================
  /// CURRENT USER
  /// =======================
  User? get currentUser => _client.auth.currentUser;

  /// =======================
  /// GET ROLE
  /// =======================
  Future<int> getRole() async {
    final user = currentUser;
    if (user == null) return 3; // fallback → employee

    final data = await _client
        .from('users')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return data?['role'] ?? 3;
  }

  /// =======================
  /// ROLE BASED NAVIGATION
  /// =======================
  Future<void> navigateBasedOnRole(BuildContext context) async {
    final role = await getRole();

    switch (role) {
      case 1:
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/manager_dashboard');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/employee_dashboard');
    }
  }
}
