import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attendance_controller.dart';

class AttendanceListScreen extends StatelessWidget {
  final int role;
  AttendanceListScreen({required this.role, super.key});

  final AttendanceController controller = AttendanceController.instance;

  String _time(String? t) =>
      t == null ? '-' : DateFormat('hh:mm a').format(DateTime.parse(t));

  String _date(String? d) =>
      d == null ? '-' : DateFormat('MMM dd, yyyy').format(DateTime.parse(d));

  Duration? _hours(String? i, String? o) =>
      i == null || o == null ? null : DateTime.parse(o).difference(DateTime.parse(i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.fetchAttendance(role),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No attendance found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (c, i) {
              final row = data[i];
              final name = role == 3
                  ? 'You'
                  : row['users']?['name'] ?? 'Employee';

              final dur = _hours(row['check_in'], row['check_out']);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(child: Text(name[0])),
                  title: Text(name),
                  subtitle: Text(_date(row['check_in'])),
                  trailing: dur == null
                      ? const Text('-')
                      : Text('${dur.inHours}h ${dur.inMinutes % 60}m'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
