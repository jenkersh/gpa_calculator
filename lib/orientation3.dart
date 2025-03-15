import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gpa_provider.dart';
import 'course_list.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation3 extends StatefulWidget {
  @override
  _Orientation3State createState() => _Orientation3State();
}

class _Orientation3State extends State<Orientation3> {
  final _targetGPAController = TextEditingController();

  String? _targetGPAError;

  void _validateTargetGPA() {
    setState(() {
      _targetGPAError = _validateGPA(_targetGPAController.text);
    });
  }

  String? _validateGPA(String value) {
    if (value.isEmpty) {
      return "Target GPA can't be empty.";
    }
    final gpa = double.tryParse(value);
    if (gpa == null || gpa < 0.0 || gpa > 4.0) {
      return "Please enter a valid GPA between 0.0 and 4.0.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter your target GPA below.",
              style: TextStyle(fontSize: 22),
            ),
            Spacer(),
            NewTextField(
              controller: _targetGPAController,
              label: "Target GPA",
              isGPAField: true,
              errorText: _targetGPAError,
              validator: (value) => _validateGPA(value),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.scrim,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              onPressed: () async {
                _validateTargetGPA(); // Validate inputs before proceeding

                // Check for errors before proceeding
                if (_targetGPAError == null) {
                  // Retrieve the input value
                  double targetGPA = double.parse(_targetGPAController.text);

                  // Update the provider with the target GPA
                  await Provider.of<GPAProvider>(context, listen: false)
                      .updateTargetGPA(targetGPA);

                  // Navigate to the next screen (CourseList)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseList()),
                  );
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
