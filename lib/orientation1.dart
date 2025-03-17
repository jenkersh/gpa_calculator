import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/orientation4.dart';
import 'package:provider/provider.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'orientation2.dart';

class Orientation1 extends StatelessWidget {
  const Orientation1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 1, // Adjust space above the question
              child: SizedBox(),
            ),
            Text(
              "Have you completed any courses at your current school?",
              style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              //textAlign: TextAlign.center,
            ),
            const Expanded(
              flex: 2, // Spacing between text and buttons
              child: SizedBox(),
            ),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () async {
                  await Provider.of<GPAProvider>(context, listen: false)
                      .togglePreviousCourses(true);
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orientation2()),
                  );
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () async {
                  await Provider.of<GPAProvider>(context, listen: false)
                      .togglePreviousCourses(false);
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orientation4()),
                  );
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 8, // Space below buttons
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
