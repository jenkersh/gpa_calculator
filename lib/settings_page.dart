import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpa_calculator/my_tile.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:gpa_calculator/gpa_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _editValue(BuildContext context, String title, dynamic currentValue, Function(dynamic) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: title == 'Previously Completed Credits'
              ? TextInputType.number
              : TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: 'Enter new $title'),
        ),
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

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          MyTile(
            title: 'Current GPA',
            value: gpaProvider.currentGPA.toStringAsFixed(2),
            onEdit: () => _editValue(
              context,
              'Current GPA',
              gpaProvider.currentGPA,
                  (val) => gpaProvider.updateCurrentGPA(val as double), // Explicitly casting
            ),
          ),
          MyTile(
            title: 'Previously Completed Credits',
            value: gpaProvider.completedCredits.toString(),
            onEdit: () => _editValue(
              context,
              'Previously Completed Credits',
              gpaProvider.completedCredits,
                  (val) => gpaProvider.updateCompletedCredits(val.toInt()),
            ),
          ),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.scrim,
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.open_in_new),
            ),
            onTap: () {
              // TODO: Implement contact functionality
            },
          ),
        ],
      ),
    );
  }
}
