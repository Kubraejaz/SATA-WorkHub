import 'package:supabase_flutter/supabase_flutter.dart';
import 'task_model.dart';

class TaskController {
  TaskController._();
  static final TaskController instance = TaskController._();

  final SupabaseClient _client = Supabase.instance.client;

  /// FETCH TASKS
  Future<List<TaskModel>> fetchTasks() async {
    final res = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return res.map<TaskModel>((e) => TaskModel.fromMap(e)).toList();
  }

  /// ADD TASK
  Future<void> addTask({
    required String title,
    required String description,
    required String assignedTo,
    String? dueDate,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await _client.from('tasks').insert({
      'title': title,
      'description': description,
      'assigned_by': user.id,
      'assigned_to': assignedTo, // MUST be auth.users.id
      'due_date': dueDate,
    }).select();

    if (response.isEmpty) {
      throw Exception('Task insert failed (RLS issue)');
    }
  }

  /// UPDATE STATUS
  Future<void> updateStatus(String taskId, String status) async {
    await _client
        .from('tasks')
        .update({'status': status})
        .eq('id', taskId);
  }
}
