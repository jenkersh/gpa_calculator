import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gpa_calculator/my_textfield.dart';
import 'package:gpa_calculator/my_tile.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _editValue(BuildContext context, String title, dynamic currentValue, Function(dynamic) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: MyTextField(nameController: controller, hintText: 'Enter new $title', hintTextColor: Theme.of(context).colorScheme.tertiary, keyboardType: title == 'Previous Credits' ? TextInputType.number : TextInputType.numberWithOptions(decimal: true)),
        // content: TextField(
        //   controller: controller,
        //   keyboardType: title == 'Previous Credits'
        //       ? TextInputType.number
        //       : TextInputType.numberWithOptions(decimal: true),
        //   decoration: InputDecoration(hintText: 'Enter new $title'),
        // ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(double.tryParse(controller.text) ?? currentValue);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("For support, email us at:"),
              SizedBox(height: 8),
              SelectableText(
                "jkershapps@gmail.com",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                HapticFeedback.lightImpact();
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'jkershapps@gmail.com',
                  //queryParameters: {'subject': 'Tip Kitty Support'},
                );

                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                } else {
                  // Close the initial dialog and then show the error dialog
                  Navigator.pop(context);
                  Future.delayed(Duration.zero, () {
                    _showErrorDialog(context);
                  });
                }
              },
              child: Text("Open Email App"),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
            "Could not open the email app. Please email jkershapps@gmail.com manually.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: SizedBox(
              width: 75,
              child: FlutterSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onToggle: (value) {
                  // Toggle dark mode theme
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
                activeText: "On", // Text to show when active
                inactiveText: "Off", // Text to show when inactive
                activeColor: Theme.of(context).colorScheme.scrim, // Color when the switch is ON
                inactiveColor: Colors.grey, // Color when the switch is OFF
                showOnOff: true, // To show "On" and "Off" text
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: const Text(
              'Previous Courses?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: SizedBox(
              width: 75,
              child: FlutterSwitch(
                value: gpaProvider.showPreviousCourses,
                onToggle: (value) {
                  gpaProvider.togglePreviousCourses(value);
                },
                activeText: "Yes",
                inactiveText: "No",
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Colors.grey,
                showOnOff: true,
              ),
            ),
          ),

          gpaProvider.showPreviousCourses == true ?
          Column(
            children: [
              MyTile(
                title: 'Previous GPA',
                value: gpaProvider.previousGrade.toStringAsFixed(2),
                onEdit: () => _editValue(
                  context,
                  'Previous GPA',
                  gpaProvider.previousGrade,
                      (val) => gpaProvider.updateCurrentGPA(val as double), // Explicitly casting
                ),
              ),
              MyTile(
                title: 'Previous Credits',
                value: gpaProvider.previousCredits.toString(),
                onEdit: () => _editValue(
                  context,
                  'Previous Credits',
                  gpaProvider.previousCredits,
                      (val) => gpaProvider.updateCompletedCredits(val.toInt()),
                ),
              ),
            ],
          ) : SizedBox(),

          MyTile(
            title: 'Target GPA',
            value: gpaProvider.targetGPA.toStringAsFixed(2),
            onEdit: () => _editValue(
              context,
              'Target GPA',
              gpaProvider.targetGPA,
                  (val) => gpaProvider.updateTargetGPA(val as double), // Explicitly casting
            ),
          ),


          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  _showEmailDialog(context);
                },
                icon: Icon(Icons.open_in_new),
              ),
            ),
            onTap: () {
              _showEmailDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
