import 'package:flutter/material.dart';
import 'task_controller.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _assignedTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: _assignedTo, decoration: const InputDecoration(labelText: 'Employee User ID')),
            const SizedBox(height: 20),
            ElevatedButton(
             onPressed: () async {
  try {
    await TaskController.instance.addTask(
      title: _title.text,
      description: _desc.text,
      assignedTo: _assignedTo.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task Assigned Successfully')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
},

              child: const Text('Assign Task'),
            )
          ],
        ),
      ),
    );
  }
}
