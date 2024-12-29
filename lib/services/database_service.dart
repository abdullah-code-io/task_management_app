import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/features/task_page/model/task_model.dart';
import 'package:task_management_app/utils/log_utils.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final databaseService = DatabaseService();

  return databaseService;
});

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late Database _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> init() async {
    Log.e('Initializing database...');
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'task_manager.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER, dueDate TEXT)',
          );
        },
        version: 1,
      );
    } catch (e) {
      Log.e('Failed to initialize database: $e');
    }
  }

  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    final List<Map<String, dynamic>> maps = await _database.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Insert a new task
  Future<void> insertTask(Task task) async {
    await _database.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
