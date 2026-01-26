import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceController {
  AttendanceController._();
  static final AttendanceController instance = AttendanceController._();

  final SupabaseClient _client = Supabase.instance.client;

  /// CHECK IN
  Future<void> checkIn() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('attendance').insert({
      'user_id': user.id,
      'check_in': DateTime.now().toIso8601String(),
      'date': DateTime.now().toIso8601String().substring(0, 10),
    });
  }

  /// CHECK OUT
  Future<void> checkOut() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('attendance')
        .update({
          'check_out': DateTime.now().toIso8601String(),
        })
        .eq('user_id', user.id)
        .eq('date', DateTime.now().toIso8601String().substring(0, 10));
  }

  /// FETCH ATTENDANCE (ROLE BASED)
  Future<List<Map<String, dynamic>>> fetchAttendance(int role) async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    late final List res;

    if (role == 3) {
      // ✅ EMPLOYEE → only own records
      res = await _client
          .from('attendance')
          .select(
            'id, user_id, check_in, check_out, date',
          )
          .eq('user_id', user.id)
          .order('date', ascending: false);
    } else {
      // ✅ ADMIN / MANAGER → ALL records
      // IMPORTANT: users!attendance_user_id_fkey
      res = await _client
          .from('attendance')
          .select(
            '''
            id,
            user_id,
            check_in,
            check_out,
            date,
            users!attendance_user_id_fkey (
              name,
              email
            )
            ''',
          )
          .order('date', ascending: false);
    }

    return List<Map<String, dynamic>>.from(res);
  }
}