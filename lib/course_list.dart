import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/add_course.dart';
import 'package:gpa_calculator/settings_page.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final List<Map<String, dynamic>> courses = [
    //{'completed': 'yes', 'name': 'Mathematics', 'grade': '2.71', 'icon': 2, 'credits': 4},
  ];
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _checkForRatingPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShownRatingPrompt = prefs.getBool('hasShownRatingPrompt') ?? false;

    if (courses.length == 1 && !hasShownRatingPrompt) {
      await prefs.setBool('hasShownRatingPrompt', true);

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    }
  }

  void _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? coursesJson = prefs.getString('courses');

    if (coursesJson != null) {
      setState(() {
        courses.clear(); // Clear existing list before adding new data
        courses.addAll(List<Map<String, dynamic>>.from(json.decode(coursesJson)));
      });
    }
  }

  double get predictedGPA {
    double totalGradePoints = 0;
    int totalCredits = 0;

    final gpaProvider = Provider.of<GPAProvider>(context, listen: false);

    // Include previous credits only if showPreviousCourses is true
    if (gpaProvider.showPreviousCourses) {
      double previousGrade = gpaProvider.previousGrade;
      int previousCredits = gpaProvider.previousCredits;

      totalGradePoints += previousGrade * previousCredits;
      totalCredits += previousCredits;
    }

    // Add each course's grade points and credits
    for (var course in courses) {
      double grade = double.tryParse(course['grade'].toString()) ?? 0.0;
      int credits = course['credits'];

      totalGradePoints += grade * credits;
      totalCredits += credits;
    }

    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  void _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('courses', json.encode(courses));
  }

  void addCourse(Map<String, dynamic> course) {
    setState(() {
      courses.add(course);
      _saveCourses(); // Save after adding
    });
    _checkForRatingPrompt();
  }

  void deleteCourse(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      courses.removeAt(index);
      _saveCourses(); // Save after deleting
    });
  }

  void editCourse(int index) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseScreen(
          courseData: courses[index],
          isEdit: true,
        ),
      ),
    ).then((updatedCourse) {
      if (updatedCourse != null) {
        setState(() {
          courses[index] = updatedCourse;
          _saveCourses(); // Save after editing
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);
    final targetGPA = gpaProvider.targetGPA;
    final bool isBelowTarget = predictedGPA < targetGPA;
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.surface,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.settings),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const SettingsPage()),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.scrim,
          foregroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () async {
            HapticFeedback.lightImpact();
            final newCourse = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (context) => AddCourseScreen()),
            );

            if (newCourse != null) {
              addCourse(newCourse);
            }
          },
          icon: Icon(Icons.add, color: Colors.black),
          label: Text("Add Course", style: TextStyle(color: Colors.black, fontSize: 16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            color: Theme.of(context).colorScheme.surface,
          ),
         if (courses.isNotEmpty || gpaProvider.showPreviousCourses == true)
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
                    color: Colors.red.withOpacity(.2), // Semi-transparent red overlay
                  ),
                ),
              Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                  icon: const Icon(Icons.settings, size: 25),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer<GPAProvider>(
              builder: (context, gpaProvider, child) {
                // If no courses and showPreviousCourses is false, display a message
                if (courses.isEmpty && gpaProvider.showPreviousCourses == false) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          isDarkMode ? 'images/backpack-white.png' : 'images/backpack-black.png', // Path to the image
                          width: 100, // Adjust width as needed
                          height: 100, // Adjust height as needed
                        ),
                        const SizedBox(height: 16), // Add some spacing between the image and text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:40),
                          child: const Text(
                            'No courses added. Press "Add Course" to enter your current and future course info!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: 100),
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
                                HapticFeedback.lightImpact();
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
                            color: Theme.of(context).colorScheme.tertiaryFixed,
                          ),
                          title: const Text(
                            "Previous Courses",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Grade: ${gpaProvider.previousGrade.toStringAsFixed(2)} \u2022 ${gpaProvider.previousCredits} credits",
                            style: TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed),
                          ),
                          onTap: () {
                            HapticFeedback.lightImpact();
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
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          SlidableAction(
                            onPressed: (context) => deleteCourse(index),
                            icon: Icons.delete,
                            backgroundColor: Colors.red.withOpacity(0.7),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        onTap: () => editCourse(index),
                        leading: Icon(
                          IconData(course['icon'], fontFamily: 'MaterialIcons'),
                          color: Theme.of(context).colorScheme.tertiaryFixed,
                        ),
                        title: Text(
                          course['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          course['completed'] == 'yes'
                              ? 'Grade: ${course['grade']} \u2022 ${course['credits']} credits'
                              : 'Predicted Grade: ${course['grade']} \u2022 ${course['credits']} credits',
                          style: TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed),
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
