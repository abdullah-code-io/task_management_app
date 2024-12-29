import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/task_page/model/task_model.dart';
import 'package:task_management_app/features/task_page/model/task_state.dart';
import 'package:task_management_app/services/database_service.dart';
import 'package:task_management_app/utils/log_utils.dart';

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return TaskNotifier(databaseService);
});

class TaskNotifier extends StateNotifier<TaskState> {
  final DatabaseService _databaseService;

  TaskNotifier(this._databaseService)
      : super(TaskState(
          tasks: [],
          sortOptions: ['By Date', 'By Priority'],
          selectedSortOption: 'By Date',
          isLoading: false,
          isError: false,
        ));

  // Load all tasks from SQLite
  Future<void> loadTasks() async {
    Log.e('Loading tasks...');
    state = state.copyWith(isLoading: true, isError: false);
    try {
      final tasks = await _databaseService.getAllTasks();
      Log.e('Loaded ${tasks.length} tasks');
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      Log.e('Failed to load tasks: $e');
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  // Add a new task to SQLite
  Future<void> addTask(Task task) async {
    try {
      await _databaseService.insertTask(task);
      loadTasks(); // Reload tasks after adding
    } catch (e) {
      Log.e('Failed to add task: $e');
    }
  }

  // Update a task's completion status in SQLite
  Future<void> updateTaskStatus(int id, bool isCompleted) async {
    try {
      await _databaseService.updateTaskCompletionStatus(id, isCompleted);
      loadTasks(); // Reload tasks after update
    } catch (e) {
      Log.e('Failed to update task status: $e');
    }
  }

  // Delete a task from SQLite
  Future<void> updateTask(int taskId, Task task) async {
    try {
      await _databaseService.updateTask(taskId, task);
      loadTasks(); // Reload tasks after delete
    } catch (e) {
      Log.e('Failed to delete task: $e');
    }
  }

  // Delete a task from SQLite
  Future<void> deleteTask(int taskId) async {
    try {
      await _databaseService.deleteTask(taskId);
      loadTasks(); // Reload tasks after delete
    } catch (e) {
      Log.e('Failed to delete task: $e');
    }
  }

  // Set the selected sort option
  void setSortOption(String option) {
    state = state.copyWith(selectedSortOption: option);
    _sortTasks();
  }

  // Sort tasks based on selected option
  void _sortTasks() {
    List<Task> sortedTasks = List.from(state.tasks);
    if (state.selectedSortOption == 'By Date') {
      sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (state.selectedSortOption == 'By Priority') {
      sortedTasks.sort((a, b) =>
          a.isCompleted ? 1 : -1); // Example sorting based on completion
    }
    state = state.copyWith(tasks: sortedTasks);
  }
}
