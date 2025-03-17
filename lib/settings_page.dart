import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
    FocusNode focusNode = FocusNode(); // Create a FocusNode

    // Ensure the keyboard opens automatically with the cursor at the end
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    });

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
                  focusNode: focusNode, // Assign the focus node
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
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
                              HapticFeedback.selectionClick();
                              setState(() {
                                controller.clear();
                                errorText = null; // Remove any previous errors
                              });

                              // Request focus and set cursor at the start after clearing
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                focusNode.requestFocus();
                                controller.selection = const TextSelection.collapsed(offset: 0);
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
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  validateAndSave(setState);
                },
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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

  void _showAboutDialog(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("About This App"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("This app utilizes the following equation for GPA calculations:"),
              SizedBox(height: 30),
              Center(
                child: Image.asset(
                  isDarkMode ? 'images/math-white.png' : 'images/math-black.png',
                  width: 230, // Adjust size as needed
                  //height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                      width: 200,
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onToggle: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                      activeText: "On",
                      inactiveText: "Off",
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveColor: Theme.of(context).colorScheme.primary,
                      activeTextColor: Theme.of(context).colorScheme.inversePrimary,
                      inactiveTextColor: Theme.of(context).colorScheme.tertiaryFixed,
                      showOnOff: true,
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
                      width: 200,
                      value: gpaProvider.showPreviousCourses,
                      onToggle: (value) {
                        gpaProvider.togglePreviousCourses(value);
                      },
                      activeText: "Yes",
                      inactiveText: "No",
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveColor: Theme.of(context).colorScheme.primary,
                      activeTextColor: Theme.of(context).colorScheme.inversePrimary,
                      inactiveTextColor: Theme.of(context).colorScheme.tertiaryFixed,
                      showOnOff: true,
                    ),
                  ),
                ),
                if (gpaProvider.showPreviousCourses)
                  Column(
                    children: [
                      MyTile(
                        title: 'Previous GPA',
                        value: gpaProvider.previousGrade.toStringAsFixed(2),
                        onEdit: () => _editValue(
                          context,
                          'Previous GPA',
                          gpaProvider.previousGrade,
                          (val) => gpaProvider.updateCurrentGPA(val as double),
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
                  ),
                MyTile(
                  title: 'Target GPA',
                  value: gpaProvider.targetGPA.toStringAsFixed(2),
                  onEdit: () => _editValue(
                    context,
                    'Target GPA',
                    gpaProvider.targetGPA,
                    (val) => gpaProvider.updateTargetGPA(val as double),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  title: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        //HapticFeedback.lightImpact();
                        _showEmailDialog(context);
                      },
                      icon: Icon(Icons.open_in_new),
                    ),
                  ),
                  onTap: () {
                    //HapticFeedback.lightImpact();
                    _showEmailDialog(context);
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  title: const Text('About This App', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        //HapticFeedback.lightImpact();
                        _showAboutDialog(context);
                      },
                      icon: Icon(Icons.open_in_new),
                    ),
                  ),
                  onTap: () {
                    //HapticFeedback.lightImpact();
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.scrim,
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Text('Save Changes', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
