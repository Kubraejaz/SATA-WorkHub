import 'package:flutter/material.dart';
import 'attendance_controller.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState
    extends State<EmployeeAttendanceScreen> {
  final AttendanceController controller =
      AttendanceController.instance;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      await controller.checkIn();
                      setState(() => loading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checked In')),
                      );
                    },
              child: const Text('CHECK IN'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      await controller.checkOut();
                      setState(() => loading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checked Out')),
                      );
                    },
              child: const Text('CHECK OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
