import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/task_form_dialog/task_form_dialog.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:consys_coding_challenge/src/utils/readable_date_time.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskDetailsScreen extends ConsumerWidget {
  const TaskDetailsScreen({super.key, required this.taskId});
  final TaskId taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskGetterProvider = taskGetterControllerProvider(taskId);
    final taskGetterControllerState = ref.watch(taskGetterProvider);

    final task = taskGetterControllerState.asData?.value;

    final title = task?.title ?? '';

    void refreshTaskData() => ref.refresh(taskGetterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (task != null) _EditTaskButton(task, onTaskSaved: refreshTaskData),
        ],
      ),
      body: taskGetterControllerState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => TaskDetailsErrorIndicator(
          error,
          onRetry: refreshTaskData,
        ),
        data: (task) => TaskDetailsView(task: task),
      ),
    );
  }
}

class _EditTaskButton extends StatelessWidget {
  const _EditTaskButton(this.task, {required this.onTaskSaved});
  final Task task;
  final void Function()? onTaskSaved;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => TaskEditFormDialog(
                  task: task,
                  onTaskSaved: onTaskSaved,
                ));
      },
    );
  }
}

class TaskDetailsErrorIndicator extends ConsumerWidget {
  const TaskDetailsErrorIndicator(this.error, {super.key, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            'Failed to load task details',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dueDate = task.dueDate;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.description ?? 'No description provided.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Priority: ${task.priority.name}',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${task.isCompleted ? "Completed" : "Incomplete"}',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Due Date: ${dueDate != null ? dueDate.toReadableString(context) : "No due date"}',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
