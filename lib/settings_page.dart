import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpa_calculator/my_tile.dart';
import 'package:gpa_calculator/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double currentGPA = 3.5;
  int completedCredits = 30;
  double targetGPA = 3.8;

  void _editValue(String title, dynamic currentValue, Function(dynamic) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: title == 'Previously Completed Credits' ? TextInputType.number : TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: 'Enter new $title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                onSave(double.tryParse(controller.text) ?? currentValue);
              });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          MyTile(
            title: 'Current GPA',
            value: currentGPA.toStringAsFixed(2),
            onEdit: () => _editValue('Current GPA', currentGPA, (val) => currentGPA = val),
          ),
          MyTile(
            title: 'Previously Completed Credits',
            value: completedCredits.toString(),
            onEdit: () => _editValue('Previously Completed Credits', completedCredits, (val) => completedCredits = val.toInt()),
          ),
          MyTile(
            title: 'Target GPA',
            value: targetGPA.toStringAsFixed(2),
            onEdit: () => _editValue('Target GPA', targetGPA, (val) => targetGPA = val),
          ),
          //const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: CupertinoSwitch(
              activeColor: Theme.of(context).colorScheme.scrim,
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: const Text(
              'Contact Us',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            //leading: const Icon(Icons.email),
            trailing: IconButton(
              onPressed: (){},
              icon: Icon(Icons.open_in_new)),
            onTap: () {
              // TODO: Implement contact functionality
            },
          ),
        ],
      ),
    );
  }
}
