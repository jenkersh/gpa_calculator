import 'package:flutter/material.dart';
import 'package:gpa_calculator/orientation3.dart';
import 'package:provider/provider.dart';
import 'gpa_provider.dart';
import 'new_textfield.dart'; // Import the NewTextField widget

class Orientation2 extends StatefulWidget {
  @override
  _Orientation2State createState() => _Orientation2State();
}

class _Orientation2State extends State<Orientation2> {
  final _creditsController = TextEditingController();
  final _creditsFocusNode = FocusNode();
  String? _creditsError;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_creditsFocusNode);
    });
  }

  void _validateAndProceed() {
    setState(() {
      _creditsError = _validateCredits(_creditsController.text);
    });

    if (_creditsError == null) {
      int previousCredits = int.parse(_creditsController.text);

      // Update provider
      Provider.of<GPAProvider>(context, listen: false)
          .updateCompletedCredits(previousCredits);

      // Navigate to Orientation3
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orientation3()),
      );
    }
  }

  String? _validateCredits(String value) {
    if (value.isEmpty) return "Completed credits can't be empty.";
    final credits = int.tryParse(value);
    if (credits == null || credits <= 0) return "Please enter a valid number of credits.";
    if (credits > 1000) return "Credits cannot exceed 1000.";
    return null;
  }

  @override
  void dispose() {
    _creditsController.dispose();
    _creditsFocusNode.dispose();
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
            Text("Awesome. How many credits have you completed?",
                style: TextStyle(fontSize: 22, letterSpacing: 1.2)),
            //Spacer(),
            SizedBox(height: 40),
            NewTextField(
              controller: _creditsController,
              label: "Completed Credits",
              errorText: _creditsError,
              validator: (value) => _validateCredits(value),
              focusNode: _creditsFocusNode, // Set focus node
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
