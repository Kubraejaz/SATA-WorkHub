import 'package:flutter/material.dart';
import 'task_controller.dart';
import 'task_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: FutureBuilder<List<TaskModel>>(
        future: TaskController.instance.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(
                    'Status: ${task.status}\n${task.description}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      TaskController.instance.updateStatus(task.id, v);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'pending', child: Text('Pending')),
                      PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                      PopupMenuItem(value: 'completed', child: Text('Completed')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}