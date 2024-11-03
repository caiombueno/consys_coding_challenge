import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskFormActionRow extends StatelessWidget {
  const TaskFormActionRow({
    super.key,
    required this.task,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.dueDate,
    required this.onSubmit,
  });

  final Task? task;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ObjectRef<TaskPriority> selectedPriority;
  final ObjectRef<DateTime?> dueDate;
  final void Function(Task) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final task = this.task;

            final title = titleController.nullableText;
            final description = descriptionController.nullableText;
            final priority = selectedPriority.value;
            final date = dueDate.value;

            final newTask = (task != null)
                ? task.edit(
                    title: title,
                    description: description,
                    priority: priority,
                    dueDate: date,
                  )
                : Task.create(
                    title: title,
                    description: description,
                    priority: priority,
                    dueDate: date,
                  );

            onSubmit(newTask);
          },
          child: Text(task == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

extension on TextEditingController {
  String? get nullableText => text.isEmpty ? null : text;
}
