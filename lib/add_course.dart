import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gpa_calculator/my_textfield.dart';
import 'package:gpa_calculator/my_tile.dart';

class AddCourseScreen extends StatefulWidget {
  final Map<String, dynamic>? courseData; // Optionally pass course data
  final bool isEdit;  // Flag to indicate if it's edit mode

  const AddCourseScreen({Key? key, this.courseData, this.isEdit = false}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  int _selectedCredits = 3; // Default to 3 credits
  bool _isCompleted = false;
  IconData _selectedIcon = Icons.school;
  final Map<String, IconData> courseIcons = {
    "Math": Icons.calculate,
    "Science": Icons.biotech,
    "History": Icons.menu_book,
    "English": Icons.book,
    "Computer Science": Icons.computer,
    "Music": Icons.music_note,
    "Art": Icons.palette,
    "Physical Education": Icons.sports_soccer,
    "Economics": Icons.attach_money,
    "Psychology": Icons.psychology,
    "Chemistry": Icons.science,
    "Physics": Icons.waves,
    "Biology": Icons.eco,
    "Geography": Icons.public,
    "Philosophy": Icons.self_improvement,
    "Business": Icons.business,
    "Engineering": Icons.build,
    "Law": Icons.gavel,
    "Medicine": Icons.local_hospital,
    "Astronomy": Icons.auto_stories,
    "Theater": Icons.theater_comedy,
    "Culinary Arts": Icons.restaurant,
    "Foreign Language": Icons.translate,
    "Literature": Icons.menu_book,
    "Political Science": Icons.account_balance
  };
  int _courseIcon = 0;

  @override
  @override
  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.courseData != null) {
      // Populate fields with existing data when editing
      _nameController.text = widget.courseData!['name'];
      _gradeController.text = widget.courseData!['grade'];
      _selectedCredits = widget.courseData!['credits'] ?? 3;
      _courseIcon = widget.courseData!['icon'];

      // Convert icon code point back to IconData
      _selectedIcon = IconData(_courseIcon, fontFamily: 'MaterialIcons');
    } else {
      // Default values for new courses
      _nameController.text = "My Course";
      _gradeController.text = "3.0"; // Set default grade to 3.0
    }
  }



  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _showCreditPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                backgroundColor: Theme.of(context).colorScheme.surface,
                itemExtent: 32,
                scrollController: FixedExtentScrollController(initialItem: _selectedCredits - 1), // Adjust index to match the range
                onSelectedItemChanged: (value) {
                  setState(() => _selectedCredits = value + 1);  // Update selectedCredits, ensuring it's 1-based
                },
                children: List.generate(10, (index) => Text('${index + 1}')), // 1-10 credits
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            )
          ],
        ),
      ),
    );
  }

  void _showEditor({required String editorType, required Function(String) onSave}) {
    TextEditingController controller;
    String title;
    String? errorText;
    String originalValue; // Store original value

    if (editorType == 'name') {
      controller = _nameController;
      title = "Edit Course Name";
      originalValue = controller.text;
    } else {
      controller = _gradeController;
      title = "Edit Grade";
      originalValue = controller.text;
    }

    void validateAndSave(StateSetter setState) {
      String input = controller.text.trim();

      if (editorType == 'name') {
        if (input.isEmpty) {
          setState(() => errorText = "Name can't be empty.");
          return;
        } else if (input.length > 30) {
          setState(() => errorText = "Max 30 chars.");
          return;
        }
      } else if (editorType == 'grade') {
        double? grade = double.tryParse(input);
        if (grade == null) {
          setState(() => errorText = "Invalid number.");
          return;
        } else if (grade < 0.00 || grade > 4.00) {
          setState(() => errorText = "Grade 0-4 only.");
          return;
        } else {
          grade = double.parse(grade.toStringAsFixed(2));
          setState(() {
            controller.text = grade.toString();
            errorText = null; // Clear error if valid
          });
        }
      }

      // Only save if there is no error
      if (errorText == null) {
        onSave(controller.text);
        Navigator.pop(context);
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: editorType == 'grade'
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: editorType == 'name' ? 'Enter course name' : 'Enter grade',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                    errorText: errorText,
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          errorText = null; // Remove any previous errors
                        });
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      errorText = null; // Reset error text when the user starts typing
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.text = originalValue; // Restore original value
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  validateAndSave(setState);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: courseIcons.length,
          itemBuilder: (context, index) {
            String courseName = courseIcons.keys.elementAt(index);
            IconData icon = courseIcons[courseName]!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(icon, size: 30, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {
                    setState(() => _selectedIcon = icon);
                    Navigator.pop(context);
                  },
                ),
                //Text(courseName, style: const TextStyle(fontSize: 12)),
              ],
            );
          },
        );
      },
    );
  }

  void _saveCourse() {
    final newCourse = {
      'completed': _isCompleted ? 'yes' : 'no',
      'name': _nameController.text.isEmpty ? "My Course" : _nameController.text,
      'grade': _gradeController.text.isEmpty ? "3.0" : _gradeController.text,
      'icon': _selectedIcon.codePoint,
      'credits': _selectedCredits,
    };

    Navigator.pop(context, newCourse);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isEdit ? 'Edit Course' : 'Add Course')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            ListTile(
              title: const Text("Course Completed?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              trailing: SizedBox(
                width: 75, // Constraint width to avoid excessive space usage
                child: FlutterSwitch(
                  value: _isCompleted,
                  onToggle: (value) => setState(() => _isCompleted = value),
                  activeText: "Yes",
                  inactiveText: "No",
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.grey,
                  showOnOff: true,
                ),
              ),
            ),
            MyTile(
              title: "Course Name",
              value: _nameController.text,
              onEdit: () => _showEditor(
                editorType: 'name',
                onSave: (newName) {
                  setState(() {
                    _nameController.text = newName.isEmpty ? "My Course" : newName;
                  });
                },
              ),
            ),

            MyTile(
              title: _isCompleted ? "Grade" : "Predicted Grade",
              value: _gradeController.text.isEmpty ? "3.0" : _gradeController.text,
              onEdit: () => _showEditor(
                editorType: 'grade',
                onSave: (newGrade) {
                  setState(() {
                    _gradeController.text = newGrade.isEmpty ? "3.0" : newGrade;
                  });
                },
              ),
            ),

            MyTile(
              title: "Credits",
              value: _selectedCredits.toString(),
              onEdit: () => _showCreditPicker(context),
            ),
            MyTile(
              title: "Course Icon",
              value: Icon(_selectedIcon, color: Theme.of(context).colorScheme.tertiary), // Not needed for icon selection
              onEdit: _showIconPicker,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.scrim,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _saveCourse,
                child: Text(widget.isEdit ? 'Save Changes' : 'Add Course', style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
