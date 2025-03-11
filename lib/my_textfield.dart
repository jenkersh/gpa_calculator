import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.nameController,
    required this.hintText,
    required this.hintTextColor,
    required this.keyboardType,
  });

  final TextEditingController nameController;
  final String hintText;
  final Color? hintTextColor;
  final TextInputType? keyboardType; // Explicitly define type

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        keyboardType: widget.keyboardType, // Use widget.keyboardType
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintTextColor, fontSize: 13),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
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
        ),
        controller: widget.nameController,
      ),
    );
  }
}
