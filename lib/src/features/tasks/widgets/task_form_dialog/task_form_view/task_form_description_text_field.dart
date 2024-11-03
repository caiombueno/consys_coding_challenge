import 'package:flutter/material.dart';

class TaskFormDescriptionTextField extends StatelessWidget {
  const TaskFormDescriptionTextField(
      {super.key, required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }
}
