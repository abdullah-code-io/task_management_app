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
        title: 'Task Management App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TaskPage(),
      ),
    );
  }
}
