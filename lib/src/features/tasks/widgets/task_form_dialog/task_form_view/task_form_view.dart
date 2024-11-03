import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'due_date_selector_widget.dart';
import 'task_form_action_row.dart';
import 'task_form_description_text_field.dart';
import 'task_form_priority_selector_widget.dart';
import 'task_form_title_text_field.dart';

class TaskFormView extends HookWidget {
  const TaskFormView({super.key, this.task, required this.onSubmit});
  final Task? task;
  final void Function(Task) onSubmit;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: task?.title ?? '');

    final descriptionController =
        useTextEditingController(text: task?.description ?? '');

    final selectedPriority =
        useRef<TaskPriority>(task?.priority ?? TaskPriority.none);

    final dueDate = useRef<DateTime?>(task?.dueDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task == null ? 'Create Task' : 'Edit Task',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TaskFormTitleTextField(titleController: titleController),
        const SizedBox(height: 12),
        TaskFormDescriptionTextField(
            descriptionController: descriptionController),
        const SizedBox(height: 12),
        TaskFormPrioritySelectorWidget(selectedPriority: selectedPriority),
        const SizedBox(height: 12),
        DueDateSelectorWidget(dueDateRef: dueDate),
        const SizedBox(height: 24),
        TaskFormActionRow(
          task: task,
          titleController: titleController,
          descriptionController: descriptionController,
          selectedPriority: selectedPriority,
          dueDate: dueDate,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}
