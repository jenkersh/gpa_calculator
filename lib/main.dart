import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/course_list.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:gpa_calculator/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final bool hasCompletedOnboarding = await _checkIfOnboardingCompleted();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GPAProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(hasCompletedOnboarding: hasCompletedOnboarding),
    ),
  );
}

Future<bool> _checkIfOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasCompletedOnboarding') ?? false;
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;
  const MyApp({super.key, required this.hasCompletedOnboarding});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPA Calculator',
          theme: themeProvider.themeData,
          home: hasCompletedOnboarding ? CourseList() : WelcomePage(),
        );
      },
    );
  }
}
