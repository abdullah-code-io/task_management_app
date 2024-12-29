class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });

  // For converting a task to a map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // For creating a task from a map (SQLite)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
}
