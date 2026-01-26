import 'package:flutter/material.dart';
import 'leave_controller.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final reasonController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Submit Leave'),
              onPressed: () async {
                await LeaveController.instance.applyLeave(
                  reason: reasonController.text,
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 2)),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
