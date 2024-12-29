import 'package:task_management_app/features/task_page/model/task_model.dart';


class TaskState {
  final List<Task> tasks;
  final List<String> sortOptions;
  final String selectedSortOption;
  final bool isLoading;
  final bool isError;

  TaskState({
    required this.tasks,
    required this.sortOptions,
    required this.selectedSortOption,
    required this.isLoading,
    required this.isError,
  });

  TaskState copyWith({
    List<Task>? tasks,
    List<String>? sortOptions,
    String? selectedSortOption,
    bool? isLoading,
    bool? isError,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      sortOptions: sortOptions ?? this.sortOptions,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}
