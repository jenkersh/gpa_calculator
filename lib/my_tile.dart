import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String title;
  final String value;
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
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
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
