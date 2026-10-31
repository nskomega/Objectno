import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.maxLength = 120,
    this.autofocus = false,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final int maxLength;
  final bool autofocus;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Semantics(
        label: label,
        child: TextFormField(
          controller: controller,
          autofocus: autofocus,
          maxLines: maxLines,
          maxLength: maxLength,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: hint),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Заполните поле' : null,
        ),
      ),
    ],
  );
}
