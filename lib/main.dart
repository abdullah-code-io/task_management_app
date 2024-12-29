import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod
import 'package:task_management_app/app_initializer.dart';
import 'package:task_management_app/features/task_page/view/task_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await AppInitializer.initialize(); // Call your app initialization method
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(  // Wrap the app with ProviderScope
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        title: 'Task Management App',
        theme: _lightTheme(), // Light theme settings
        darkTheme: _darkTheme(),
        home: const TaskPage(),
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black54),
        bodyLarge: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueAccent,
      appBarTheme: const AppBarTheme(
        color: Colors.blueAccent,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        bodyLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
