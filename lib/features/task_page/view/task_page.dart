import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/features/task_page/model/task_model.dart';
import 'package:task_management_app/features/task_page/model/task_state.dart';
import 'package:task_management_app/features/task_page/view_model/task_view_model.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  @override
  void initState() {
    // Trigger loading of tasks after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).loadTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    // if (taskState.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // if (taskState.isError) {
    //   return const Center(child: Text('Failed to load tasks.'));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle sorting or filtering
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All task',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                )),
            const SizedBox(height: 10),
            Expanded(child: _buildMobileLayout(taskState)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout(TaskState taskState) {
    // Build layout for mobile
    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        final task = taskState.tasks[index];
        return TaskCardWidget(
          task: task,
          onTaskComplete: (isCompleted) {
            ref
                .read(taskNotifierProvider.notifier)
                .updateTaskStatus(task.id, isCompleted);
          },
          onTaskEdit: (updatedTask) {
            ref
                .read(taskNotifierProvider.notifier)
                .updateTask(task.id, updatedTask);
          },
          onTaskDelete: () {
            ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDueDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Add Task",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDueDate == null
                            ? "No due date selected"
                            : "Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDueDate!)}",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    )),
              ),
              TextButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();

                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        selectedDueDate != null) {
                      ref.read(taskNotifierProvider.notifier).addTask(
                            Task(
                              id: DateTime.now().millisecondsSinceEpoch,
                              // Generate unique ID
                              title: title,
                              description: description,
                              isCompleted: false,
                              dueDate: selectedDueDate!,
                            ),
                          );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please fill all fields and select a due date.",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                        ),
                      );
                    }
                  },
                  child: Text("Add",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ))),
            ],
          );
        });
      },
    );
  }
}

class TaskCardWidget extends StatefulWidget {
  final Task task;
  final Function(bool) onTaskComplete;
  final Function(Task) onTaskEdit;
  final Function() onTaskDelete;

  const TaskCardWidget(
      {super.key,
      required this.task,
      required this.onTaskComplete,
      required this.onTaskEdit,
      required this.onTaskDelete});

  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded; // Toggle the expansion state
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]  // Dark theme background color
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 12,
                          color: Colors.grey,
                        ),
                        Text(
                          DateFormat('EEEE, hh:mm a')
                              .format(widget.task.dueDate),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                CheckBoxRounded(
                  isChecked: widget.task.isCompleted,
                  checkedColor: Colors.blue,
                  onTap: (bool? value) {
                    widget.onTaskComplete(value!);
                  },
                ),
              ],
            ),
            // Animated expansion
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              // Empty widget when collapsed
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 55),
                child: Row(
                  children: [
                    Text(
                      'Description: ',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                    Text(
                      widget.task.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () async {
                          final updatedTask =
                              await _showEditTaskDialog(context, widget.task);
                          if (updatedTask != null) {
                            widget.onTaskEdit(updatedTask);
                          }
                        },
                        child: Icon(Icons.edit)),
                    SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          widget.onTaskDelete();
                        },
                        child: Icon(Icons.delete)),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }

  Future<Task?> _showEditTaskDialog(BuildContext context, Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime? selectedDueDate = task.dueDate;

    // Wait for the dialog result asynchronously
    return await showDialog<Task?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Update Task",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            selectedDueDate == null
                                ? "No due date selected"
                                : "Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDueDate!)}",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            )),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDueDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();

                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        selectedDueDate != null) {
                      // Return the updated task
                      final updatedTask = Task(
                        id: task.id,
                        // Keep the original ID
                        title: title,
                        description: description,
                        isCompleted: task.isCompleted,
                        // Keep the original completion status
                        dueDate: selectedDueDate!,
                      );

                      Navigator.of(context).pop(
                          updatedTask); // Close the dialog and return the updated task
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please fill all fields and select a due date.",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                        ),
                      );
                    }
                  },
                  child: Text("Update",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      )),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
