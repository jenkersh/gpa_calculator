import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/orientation4.dart';
import 'package:provider/provider.dart';
import 'gpa_provider.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation3 extends StatefulWidget {
  const Orientation3({super.key});

  @override
  _Orientation3State createState() => _Orientation3State();
}

class _Orientation3State extends State<Orientation3> {
  final _gpaController = TextEditingController();
  final _gpaFocusNode = FocusNode();
  String? _gpaError;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_gpaFocusNode);
    });
  }

  void _validateAndProceed() {
    HapticFeedback.lightImpact();
    setState(() {
      _gpaError = _validateGPA(_gpaController.text);
    });

    if (_gpaError == null) {
      double previousGPA = double.parse(_gpaController.text);

      // Update provider
      Provider.of<GPAProvider>(context, listen: false)
          .updateCurrentGPA(previousGPA);

      // Navigate to main course list page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orientation4()),
      );
    }
  }

  String? _validateGPA(String value) {
    if (value.isEmpty) return "Current GPA can't be empty.";
    final gpa = double.tryParse(value);
    if (gpa == null || gpa < 0.0 || gpa > 4.0) return "Enter a valid number (up to 4.0).";
    return null;
  }

  @override
  void dispose() {
    _gpaController.dispose();
    _gpaFocusNode.dispose();
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
          children: <Widget>[
            Text("Great! What's your current GPA? (you can change this later)",
                style: TextStyle(fontSize: 22, letterSpacing: 1.2)),
            //Spacer(),
            SizedBox(height: 40),
            NewTextField(
              controller: _gpaController,
              label: "Current GPA",
              isGPAField: true,
              errorText: _gpaError,
              validator: (value) => _validateGPA(value),
              focusNode: _gpaFocusNode, // Set focus node
            ),
            //Spacer(),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.scrim,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              onPressed: _validateAndProceed,
              child: Text("Continue", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
