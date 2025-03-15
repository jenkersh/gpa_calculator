import 'package:flutter/material.dart';
import 'package:gpa_calculator/orientation3.dart';
import 'package:provider/provider.dart';
import 'gpa_provider.dart';
import 'course_list.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation2 extends StatefulWidget {
  @override
  _Orientation2State createState() => _Orientation2State();
}

class _Orientation2State extends State<Orientation2> {
  final _creditsController = TextEditingController();
  final _gpaController = TextEditingController();

  String? _creditsError;
  String? _gpaError;

  void _validateInputs() {
    setState(() {
      _creditsError = _validateCredits(_creditsController.text);
      _gpaError = _validateGPA(_gpaController.text);
    });
  }

  String? _validateCredits(String value) {
    if (value.isEmpty) {
      return "Completed credits can't be empty.";
    }
    final credits = int.tryParse(value);
    if (credits == null || credits <= 0) {
      return "Please enter a valid number of credits.";
    }
    if (credits > 1000) {
      return "Credits cannot exceed 1000.";
    }
    return null;
  }

  String? _validateGPA(String value) {
    if (value.isEmpty) {
      return "Current GPA can't be empty.";
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
              "Enter the number of credits you've completed and your current GPA below.",
              style: TextStyle(fontSize: 22),
            ),
            Spacer(),
            NewTextField(
              controller: _creditsController,
              label: "Completed Credits",
              errorText: _creditsError,
              validator: (value) => _validateCredits(value),
            ),
            NewTextField(
              controller: _gpaController,
              label: "Current GPA",
              isGPAField: true,
              errorText: _gpaError,
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
                _validateInputs(); // Validate inputs before proceeding

                // Check for errors before proceeding
                if (_creditsError == null && _gpaError == null) {
                  // Retrieve the input values
                  int previousCredits = int.parse(_creditsController.text);
                  double previousGPA = double.parse(_gpaController.text);

                  // Update the provider with the values
                  await Provider.of<GPAProvider>(context, listen: false)
                      .updateCompletedCredits(previousCredits);
                  await Provider.of<GPAProvider>(context, listen: false)
                      .updateCurrentGPA(previousGPA);

                  // Navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orientation3()),
                  );
                }
              },
              child: Text("Continue", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
