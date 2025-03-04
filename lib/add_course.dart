import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gpa_calculator/my_tile.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  int _selectedCredits = 3;
  bool _isCompleted = false;
  IconData _selectedIcon = Icons.school;

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
                scrollController: FixedExtentScrollController(initialItem: _selectedCredits),
                onSelectedItemChanged: (value) {
                  setState(() => _selectedCredits = value);
                },
                children: List.generate(11, (index) => Text('$index')), // 0-10 credits
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

  void _showEditor({required String editorType}) {
    TextEditingController controller;
    String title;

    if (editorType == 'name') {
      controller = _nameController;
      title = "Edit Course Name";
    } else {
      controller = _gradeController;
      title = "Edit Grade";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: editorType == 'grade' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            decoration: InputDecoration(hintText: editorType == 'name' ? 'Enter course name' : 'Enter grade'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
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
          itemCount: 10,
          itemBuilder: (context, index) {
            final icon = Icons.circle;
            return IconButton(
              icon: Icon(icon, size: 30),
              onPressed: () {
                setState(() => _selectedIcon = icon);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _saveCourse() {
    final newCourse = {
      'completed': _isCompleted ? 'yes' : 'no',
      'name': _nameController.text,
      'grade': _gradeController.text,
      'icon': _selectedIcon.toString(),
      'credits': _selectedCredits,
    };

    Navigator.pop(context, newCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
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

            //Divider(color: Colors.grey.shade300, thickness: 1, indent: 20, endIndent: 20),
            MyTile(
              title: "Course Name",
              value: _nameController.text.isEmpty ? "My Course" : _nameController.text,
              onEdit: () => _showEditor(editorType: 'name'),
            ),
            MyTile(
              title: _isCompleted ? "Grade" : "Predicted Grade",
              value: _gradeController.text.isEmpty ? "0.0" : _gradeController.text,
              onEdit: () => _showEditor(editorType: 'grade'),
            ),
            MyTile(
              title: "Icon",
              value: "Selected Icon",
              onEdit: _showIconPicker,
            ),
            MyTile(
              title: "Credits",
              value: _selectedCredits.toString(),
              onEdit: () => _showCreditPicker(context),
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
                child: Text("Save Course", style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
