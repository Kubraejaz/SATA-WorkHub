import 'package:supabase_flutter/supabase_flutter.dart';

class LeaveController {
  LeaveController._();
  static final LeaveController instance = LeaveController._();

  final SupabaseClient _client = Supabase.instance.client;

  /// APPLY LEAVE (Employee)
  Future<void> applyLeave({
    required String reason,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('leaves').insert({
      'user_id': user.id,
      'reason': reason,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    });
  }

  /// FETCH LEAVES (ROLE BASED)
  Future<List<Map<String, dynamic>>> fetchLeaves(int role) async {
    final user = _client.auth.currentUser;

    if (role == 3) {
      // Employee
      final res = await _client
          .from('leaves')
          .select()
          .eq('user_id', user!.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } else {
      // Admin / Manager
      final res = await _client
          .from('leaves')
          .select('*, users(email)')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    }
  }

  /// UPDATE STATUS (Admin / Manager)
  Future<void> updateLeaveStatus(String leaveId, String status) async {
    await _client
        .from('leaves')
        .update({'status': status})
        .eq('id', leaveId);
  }
}
