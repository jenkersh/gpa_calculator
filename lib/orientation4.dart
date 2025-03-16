import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gpa_provider.dart';
import 'course_list.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation4 extends StatefulWidget {
  const Orientation4({super.key});

  @override
  _Orientation4State createState() => _Orientation4State();
}

class _Orientation4State extends State<Orientation4> {
  final _targetGPAController = TextEditingController();
  final _targetGPAFocusNode = FocusNode();
  String? _targetGPAError;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_targetGPAFocusNode);
    });
  }

  void _validateTargetGPA() {
    HapticFeedback.lightImpact();
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

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
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
            Text(
              "What would you like your GPA to be? (you can change this later)",
              style: TextStyle(fontSize: 22, letterSpacing: 1.2),
            ),
            SizedBox(height: 40),
            NewTextField(
              controller: _targetGPAController,
              label: "Target GPA",
              isGPAField: true,
              errorText: _targetGPAError,
              validator: (value) => _validateGPA(value),
              focusNode: _targetGPAFocusNode,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.scrim,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              onPressed: () async {
                _validateTargetGPA();

                if (_targetGPAError == null) {
                  double targetGPA = double.parse(_targetGPAController.text);

                  // Update GPA provider
                  await Provider.of<GPAProvider>(context, listen: false)
                      .updateTargetGPA(targetGPA);

                  // Mark onboarding as complete
                  await _completeOnboarding();

                  // Remove all previous screens and navigate to CourseList
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CourseList()),
                        (route) => false, // Remove all previous routes
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
