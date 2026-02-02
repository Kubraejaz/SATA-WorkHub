class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String assignedTo;
  final String assignedBy;
  final String? dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.assignedBy,
    this.dueDate,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      status: map['status'],
      assignedTo: map['assigned_to'],
      assignedBy: map['assigned_by'],
      dueDate: map['due_date'],
    );
  }
}