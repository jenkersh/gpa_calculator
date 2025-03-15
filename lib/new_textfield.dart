import 'package:flutter/material.dart';

class NewTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isGPAField;
  final String? Function(String)? validator; // Validation function
  final String? errorText; // Display error message

  NewTextField({
    required this.controller,
    required this.label,
    this.isGPAField = false,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: isGPAField
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiaryFixed,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.8),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                // Ensures full outline when error occurs
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2, // Keeps the thickness the same
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                // Ensures full outline remains on focus
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              errorText: errorText, // Display the error text
            ),
            onChanged: (value) {
              // Call the validator every time the text changes
              if (validator != null) {
                validator!(value); // This triggers error logic
              }
            },
          ),
          // if (errorText != null)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 8.0),
          //     child: Text(
          //       errorText!,
          //       style: TextStyle(color: Colors.red, fontSize: 12),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
