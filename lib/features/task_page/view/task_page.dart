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
        title: const Text('Task Manager'),
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
      body: _buildMobileLayout(taskState),
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
        return TaskCardWidget(task: task);
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
        return AlertDialog(
          title: const Text("Add Task"),
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
                        selectedDueDate = pickedDate;
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
              child: const Text("Cancel"),
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
                    const SnackBar(
                      content:
                          Text("Please fill all fields and select a due date."),
                    ),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class TaskCardWidget extends StatefulWidget {
  final Task task;
  const TaskCardWidget({super.key, required this.task});

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
          color: Colors.white,
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                CheckBoxRounded(
                  checkedColor: Colors.blue,
                  onTap: (bool? value) {},
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
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      widget.task.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
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
}
