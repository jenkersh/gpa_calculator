import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.nameController,
    required this.hintText,
    required this.hintTextColor,
    required this.keyboardType,
    required this.inputFormatters, // Accept input formatters
    required this.validator, // Validation function
  });

  final TextEditingController nameController;
  final String hintText;
  final Color? hintTextColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?) validator; // Validator function

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String? _errorText;

  void _validateInput(String value) {
    setState(() {
      _errorText = widget.validator(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          controller: widget.nameController,
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
            errorText: _errorText, // Display error message
          ),
          onChanged: _validateInput,
        ),
      ],
    );
  }
}
