import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/add_course.dart';
import 'package:gpa_calculator/settings_page.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final List<Map<String, dynamic>> courses = [
    {'completed': 'yes', 'name': 'Mathematics', 'grade': '2.71', 'icon': 'house', 'credits': 4},
  ];

  double get predictedGPA {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      // Safely parse the grade from String to Double
      double grade = double.tryParse(course['grade'].toString()) ?? 0.0;
      int credits = course['credits'];

      totalGradePoints += grade * credits;
      totalCredits += credits;
    }

    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }


  void addCourse(Map<String, dynamic> course) {
    setState(() {
      courses.add(course);
    });
  }

  void deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        //title: const Text('GPA Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.scrim,
          foregroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () async {
            // Navigate to AddCourseScreen and wait for the returned data
            final newCourse = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => AddCourseScreen()),
            );

            // If a course was returned, add it to the list
            if (newCourse != null) {
              addCourse(newCourse);
            }
          },
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Theme.of(context).colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: Text(
              'Predicted GPA: ${predictedGPA.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: courses.isEmpty
                ? const Center(child: Text('No courses added. Press the "+" to start!'))
                : ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deleteCourse(index),
                        icon: Icons.delete,
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // TODO: Implement edit course details
                    },
                    leading: Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                    title: Text(
                      course['name'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Grade: ${course['grade']} \u2022 ${course['credits']} credits',
                      style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  indent: 20,
                  endIndent: 20,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
