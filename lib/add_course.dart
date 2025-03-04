import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gpa_calculator/my_textfield.dart';

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

  void _showEditor({required String editorType}) {
    TextEditingController _controller;
    TextInputType inputType;

    // Set the controller and keyboard type based on the editor type
    if (editorType == 'name') {
      _controller = _nameController; // Use the name controller for name editing
      inputType = TextInputType.text; // Regular keyboard for text input
    } else {
      _controller = _gradeController; // Use the grade controller for grade editing
      inputType = TextInputType.numberWithOptions(decimal: true); // Numeric keyboard with decimal support
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(editorType == 'name' ? "Edit Course Name" : "Edit Grade"),
          content: TextField(
            controller: _controller,
            keyboardType: inputType, // Set the keyboard type
            decoration: InputDecoration(
              hintText: editorType == 'name' ? 'Enter course name' : 'Enter grade',
            ),
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


  void _saveCourse() {
    // TODO: Implement saving logic
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Course Completed?"),
                FlutterSwitch(
                  value: _isCompleted,
                  onToggle: (value) => setState(() => _isCompleted = value),
                  activeText: "Yes",
                  inactiveText: "No",
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.grey,
                  showOnOff: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Course Name"),
                Row(
                  children: [
                    Text(_nameController.text.isEmpty ? "Not Set" : _nameController.text),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditor(editorType: 'name'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isCompleted ? "Grade" : "Predicted Grade"),
                Row(
                  children: [
                    Text(_gradeController.text.isEmpty ? "Not Set" : _gradeController.text),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditor(editorType: 'grade'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Icon"),
                Row(
                  children: [
                    Icon(_selectedIcon),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _showIconPicker,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Credits"),
                Row(
                  children: [
                    Text(_selectedCredits.toString()),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showCreditPicker(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveCourse,
                child: Text(
                  "Save Course",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
