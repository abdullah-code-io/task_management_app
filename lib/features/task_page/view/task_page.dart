import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/features/task_page/model/task_model.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Handle sorting or filtering
            },
          ),
        ],
      ),
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task page
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 1, // Replace with the task count
        itemBuilder: (context, index) {
          return TaskCardWidget(index: index);
        },
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1, child: _buildMobileLayout(), // Task list
        ),
        VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: Center(
            child: Text('Select a task to view details'),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(int index) {
    List<TaskModel> _taskList = [
      TaskModel(
        title: 'Take a break',
        description: 'Task Description $index',
        date: DateTime.now(),
        isCompleted: false,
      ),
    ];
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 45.0,
            // Icon size
            height: 45.0,
            decoration: BoxDecoration(
              color: Colors.blue, // Background color of the icon
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0, // Font size for initials
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _taskList[index].title,
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
                    DateFormat('EEEE, hh:mm a').format(_taskList[index].date),
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
    );
  }
}

class TaskCardWidget extends StatefulWidget {
  final int index;
  TaskCardWidget({required this.index});

  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<TaskModel> _taskList = [
      TaskModel(
        title: 'Take a break',
        description: 'Task Description ${widget.index}',
        date: DateTime.now(),
        isCompleted: false,
      ),
    ];

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
              color: Colors.grey.withOpacity(0.5),
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
                      _taskList[widget.index].title,
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
                              .format(_taskList[widget.index].date),
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
            ), // Animated expansion
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
                      _taskList[widget.index].description,
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
