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
    String? errorText;

    void validateAndSave(StateSetter setState) {
      String input = controller.text.trim();
      double? inputValue = double.tryParse(input);

      if (input.isEmpty) {
        setState(() => errorText = "$title can't be empty.");
        return;
      }

      if (inputValue == null) {
        setState(() => errorText = "Please enter a valid number.");
      } else if (title == 'Previous Credits' || title == 'Completed Credits') {
        if (inputValue < 0.5 || inputValue > 1000 || (inputValue * 10) % 5 != 0) {
          setState(() => errorText = "0.5 increments up to 1000 allowed.");
        } else {
          onSave(inputValue);
          Navigator.pop(context);
          return;
        }
      } else if (title == 'Previous GPA' || title == 'Target GPA') {
        if (inputValue < 0.00 || inputValue > 4.00) {
          setState(() => errorText = "GPA must be between 0.0 and 4.0.");
        } else {
          // Round to two decimal places
          inputValue = double.parse(inputValue.toStringAsFixed(2));
          onSave(inputValue);
          Navigator.pop(context);
          return;
        }
      }

      // Force dialog rebuild to show error
      setState(() {});
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit $title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary.withOpacity(.7),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(  // Ensures full outline when error occurs
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,  // Keeps the thickness the same
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(  // Ensures full outline remains on focus
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    hintText: 'Enter new $title',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                    errorText: errorText,
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          errorText = null; // Remove any previous errors
                        });
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      errorText = null; // Reset error text when the user starts typing
                    });
                  },
                ),

              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  validateAndSave(setState);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
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
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
            contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
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
