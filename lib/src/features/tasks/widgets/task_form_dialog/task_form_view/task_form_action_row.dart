import 'package:consys_coding_challenge/src/features/reminders/controllers/task_reminder_creator_controller.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskFormActionRow extends HookConsumerWidget {
  const TaskFormActionRow({
    super.key,
    required this.task,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.dueDate,
    required this.reminderDate,
    required this.onSubmit,
  });

  final Task? task;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ObjectRef<TaskPriority> selectedPriority;
  final ObjectRef<DateTime?> dueDate;
  final ObjectRef<DateTime?> reminderDate;
  final void Function(Task) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskReminderCreatorController =
        ref.read(taskReminderCreatorControllerProvider.notifier);

    ref.listen(taskReminderCreatorControllerProvider, (prev, next) {
      if (next.asData?.value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create reminder'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
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

            final reminderDateValue = reminderDate.value;
            if (reminderDateValue != null) {
              await taskReminderCreatorController.createReminder(
                task: newTask,
                scheduledDate: reminderDateValue,
              );
            }

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
