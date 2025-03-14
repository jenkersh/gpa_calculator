import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String title;
  final dynamic value; // Can be either String or Widget
  final VoidCallback onEdit;

  const MyTile({
    super.key,
    required this.title,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Align(
              alignment: Alignment.centerLeft, // Ensures left alignment
              child: value is String
                  ? Text(
                value,
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.tertiaryFixed),
              )
                  : value, // Use the widget directly if not a string
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}
