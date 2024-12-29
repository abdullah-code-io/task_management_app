import 'package:task_management_app/services/database_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await DatabaseService().init();
    // Perform your app initialization tasks here
    // For example, initialize shared preferences, set up dependencies, etc.
  }
}
