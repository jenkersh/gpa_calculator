import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/orientation1.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/welcomeimage.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(.6),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(.5),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Expanded(
                  flex: 2, // Adjusts space above the title
                  child: SizedBox(),
                ),
                Column(
                  children: [
                    Text(
                      "GPA Calculator",
                      style: TextStyle(fontSize: 35, height: 0.9, letterSpacing: 4),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "PRO",
                      style: TextStyle(fontSize: 43, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Expanded(
                  flex: 10, // Proportional spacing in the middle
                  child: SizedBox(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.scrim,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 10,
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Orientation1()),
                    );
                  },
                  child: Text("Calculate My GPA", style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const Expanded(
                  flex: 1, // Adjusts space below the button
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
