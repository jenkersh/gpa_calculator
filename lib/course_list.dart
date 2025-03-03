import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final List<Map<String, dynamic>> courses = [
    {'name': 'Mathematics', 'grade': 'A', 'credits': 3},
    {'name': 'Physics', 'grade': 'B+', 'credits': 4},
    {'name': 'History', 'grade': 'A-', 'credits': 3},
  ];

  double get predictedGPA {
    return 3.8;
  }

  void deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.scrim,
          foregroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            // TODO: Implement Add Course functionality
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
                        onPressed: (context) {
                          // TODO: Implement edit functionality
                        },
                        icon: Icons.edit,
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
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
                      // TODO: Implement course details navigation
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
