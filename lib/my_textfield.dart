import 'package:flutter/material.dart';
//import 'package:session_buddy/constants.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.nameController,
    required this.hintText,
    required this.hintTextColor,
  });

  final TextEditingController nameController;
  final String hintText;
  final Color? hintTextColor;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   boxShadow: [Constants.softShadow],
      // ),
      child: TextField(
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintTextColor, fontSize: 13),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, // Keep this color when not focused
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.7),
                width: 2 // Same color when focused
            ),
          ),
        ),
        controller: widget.nameController,
      ),
    );
  }
}