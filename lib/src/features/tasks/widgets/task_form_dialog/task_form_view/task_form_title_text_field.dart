import 'package:flutter/material.dart';

class TaskFormTitleTextField extends StatelessWidget {
  const TaskFormTitleTextField({super.key, required this.titleController});

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }
}
