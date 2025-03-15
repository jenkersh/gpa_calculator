import 'package:flutter/material.dart';
import 'package:gpa_calculator/orientation3.dart';
import 'package:provider/provider.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:gpa_calculator/course_list.dart';
import 'orientation2.dart';

class Orientation1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Orientation")),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Have you completed any courses at your current school?",
              style: TextStyle(fontSize: 22),
            ),
            //SizedBox(height: 20),
            Spacer(),
            Container(
              width: 200,
              child: OutlinedButton(
                onPressed: () async {
                  // Set the showPreviousCourses value to true if "Yes"
                  await Provider.of<GPAProvider>(context, listen: false)
                      .togglePreviousCourses(true);

                  // Navigate to the next screen if "Yes"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orientation2()),
                  );
                },
                child: Text("Yes", style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: OutlinedButton(
                onPressed: () async {
                  // Set the showPreviousCourses value to false if "No"
                  await Provider.of<GPAProvider>(context, listen: false)
                      .togglePreviousCourses(false);

                  // End the orientation if "No"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orientation3()),
                  );
                },
                child: Text("No", style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary, fontSize: 20)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
