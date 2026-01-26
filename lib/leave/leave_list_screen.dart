import 'package:flutter/material.dart';
import 'leave_controller.dart';

class LeaveListScreen extends StatelessWidget {
  final int role;
  LeaveListScreen({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Requests')),
      body: FutureBuilder(
        future: LeaveController.instance.fetchLeaves(role),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final leaves = snapshot.data as List;

          if (leaves.isEmpty) {
            return const Center(child: Text('No leave requests'));
          }

          return ListView.builder(
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final leave = leaves[index];

              return ListTile(
                title: Text(leave['reason'] ?? ''),
                subtitle: Text(
                    '${leave['start_date']} → ${leave['end_date']}'),
                trailing: Text(leave['status']),
              );
            },
          );
        },
      ),
    );
  }
}
