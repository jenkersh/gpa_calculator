import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gpa_provider.dart';
import 'course_list.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation4 extends StatefulWidget {
  @override
  _Orientation4State createState() => _Orientation4State();
}

class _Orientation4State extends State<Orientation4> {
  final _targetGPAController = TextEditingController();
  final _targetGPAFocusNode = FocusNode(); // FocusNode for auto-focus
  String? _targetGPAError;

  @override
  void initState() {
    super.initState();
    // Delay focus request to ensure the screen is fully built
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_targetGPAFocusNode);
    });
  }

  void _validateTargetGPA() {
    setState(() {
      _targetGPAError = _validateGPA(_targetGPAController.text);
    });
  }

  String? _validateGPA(String value) {
    if (value.isEmpty) return "Target GPA can't be empty.";
    final gpa = double.tryParse(value);
    if (gpa == null || gpa < 0.0 || gpa > 4.0) return "Enter a valid number (up to 4.0).";
    return null;
  }

  @override
  void dispose() {
    _targetGPAController.dispose();
    _targetGPAFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("What would you like your GPA to be?",
              style: TextStyle(fontSize: 22, letterSpacing: 1.2),
            ),
            //Spacer(),
            SizedBox(height: 40),
            NewTextField(
              controller: _targetGPAController,
              label: "Target GPA",
              isGPAField: true,
              errorText: _targetGPAError,
              validator: (value) => _validateGPA(value),
              focusNode: _targetGPAFocusNode, // Auto-focus applied here
            ),
            //Spacer(),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.scrim,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              onPressed: () async {
                _validateTargetGPA(); // Validate inputs before proceeding

                if (_targetGPAError == null) {
                  double targetGPA = double.parse(_targetGPAController.text);

                  // Update the provider with the target GPA
                  await Provider.of<GPAProvider>(context, listen: false)
                      .updateTargetGPA(targetGPA);

                  // Navigate to the CourseList page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseList()),
                  );
                }
              },
              child: Text("Continue", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
