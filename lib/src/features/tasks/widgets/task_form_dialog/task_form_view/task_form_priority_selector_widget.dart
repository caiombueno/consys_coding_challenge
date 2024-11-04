import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskFormPrioritySelectorWidget extends StatelessWidget {
  const TaskFormPrioritySelectorWidget(
      {super.key, required this.selectedPriority});

  final ObjectRef<TaskPriority> selectedPriority;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TaskPriority>(
      value: selectedPriority.value,
      items: TaskPriority.values
          .map((priority) => DropdownMenuItem(
                value: priority,
                child: Text(priority.name),
              ))
          .toList(),
      onChanged: (priority) =>
          selectedPriority.value = priority ?? TaskPriority.none,
      decoration: const InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(),
      ),
    );
  }
}
