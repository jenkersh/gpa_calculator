import 'package:flutter/material.dart';

class NewTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isGPAField;
  final String? Function(String)? validator;
  final String? errorText;
  final FocusNode? focusNode;

  NewTextField({
    required this.controller,
    required this.label,
    this.isGPAField = false,
    this.validator,
    this.errorText,
    this.focusNode,
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
            focusNode: focusNode,
            keyboardType: isGPAField
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 16,
                color: errorText != null ? Colors.red : Theme.of(context).colorScheme.tertiaryFixed,
              ),
              errorStyle: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiaryFixed,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Theme.of(context).colorScheme.inversePrimary.withOpacity(.8),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}
