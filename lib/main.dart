import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/course_list.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => GPAProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPA Calculator',
          theme: themeProvider.themeData,
          home: const CourseList(),
        );
      },
    );
  }
}
