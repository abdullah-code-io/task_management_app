class TaskModel {
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });
}
