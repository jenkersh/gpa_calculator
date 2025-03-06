import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/add_course.dart';
import 'package:gpa_calculator/settings_page.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:provider/provider.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final List<Map<String, dynamic>> courses = [
    {'completed': 'yes', 'name': 'Mathematics', 'grade': '2.71', 'icon': 2, 'credits': 4},
  ];

  double get predictedGPA {
    double totalGradePoints = 0;
    int totalCredits = 0;

    // Include previous credits and grade
    final gpaProvider = Provider.of<GPAProvider>(context, listen: false);
    double previousGrade = gpaProvider.previousGrade;
    int previousCredits = gpaProvider.previousCredits;

    // Add previous credits to total
    totalGradePoints += previousGrade * previousCredits;
    totalCredits += previousCredits;

    // Add each course's grade points and credits
    for (var course in courses) {
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

  void editCourse(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseScreen(
          courseData: courses[index],  // Pass the existing course data
          isEdit: true,  // Flag to indicate edit mode
        ),
      ),
    ).then((updatedCourse) {
      if (updatedCourse != null) {
        setState(() {
          courses[index] = updatedCourse;  // Update the course in the list
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);
    final targetGPA = gpaProvider.targetGPA;
    final bool isBelowTarget = predictedGPA < targetGPA;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.scrim,
          foregroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () async {
            final newCourse = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => AddCourseScreen()),
            );

            if (newCourse != null) {
              addCourse(newCourse);
            }
          },
          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
          label: const Text("Add Course"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).colorScheme.primaryContainer,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          color: isBelowTarget ? Colors.red : Theme.of(context).colorScheme.inversePrimary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Predicted GPA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '${predictedGPA.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      isBelowTarget ? "You are NOT on track to meet your target." : "You are on track to meet your target!",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.9)),
                    ),
                  ],
                ),
              ),
              if (isBelowTarget) // Overlay only if GPA is below target
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context).colorScheme.error.withOpacity(.3), // Semi-transparent red overlay
                  ),
                ),
            ],
          ),
          Expanded(
            child: Consumer<GPAProvider>(
              builder: (context, gpaProvider, child) {
                // If no courses and showPreviousCourses is false, display a message
                if (courses.isEmpty && !gpaProvider.showPreviousCourses) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'images/backpack.png', // Path to the image
                          width: 100, // Adjust width as needed
                          height: 100, // Adjust height as needed
                        ),
                        const SizedBox(height: 16), // Add some spacing between the image and text
                        const Text(
                          'No courses added.\n Press "Add Course" to start!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  )
                  ;
                }

                return ListView.separated(
                  itemCount: courses.length + (gpaProvider.showPreviousCourses && gpaProvider.previousCredits > 0 ? 1 : 0), // Conditionally add the previous credits tile
                  itemBuilder: (context, index) {
                    if (gpaProvider.showPreviousCourses && gpaProvider.previousCredits > 0 && index == courses.length) {
                      // Slidable "Previous Credits" tile
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                                );
                              },
                              icon: Icons.edit,
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                          leading: Icon(
                            Icons.history,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          title: const Text(
                            "Previous Credits",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Grade: ${gpaProvider.previousGrade.toStringAsFixed(2)} \u2022 ${gpaProvider.previousCredits} credits",
                            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsPage()),
                            );
                          },
                        ),
                      );
                    }

                    final course = courses[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => editCourse(index),
                            icon: Icons.edit,
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                        onTap: () => editCourse(index),
                        leading: Icon(
                          IconData(course['icon'], fontFamily: 'MaterialIcons'),
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        title: Text(
                          course['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          course['completed'] == 'yes'
                              ? 'Grade: ${course['grade']} \u2022 ${course['credits']} credits'
                              : 'Predicted Grade: ${course['grade']} \u2022 ${course['credits']} credits',
                          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).colorScheme.primary,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                );
              },
            ),
          )


        ],
      ),
    );
  }
}
