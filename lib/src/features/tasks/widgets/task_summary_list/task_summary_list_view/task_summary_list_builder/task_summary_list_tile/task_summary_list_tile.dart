import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:consys_coding_challenge/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'task_summary_list_tile_checkbox.dart';

class DismissibleTaskSummaryListTile extends HookConsumerWidget {
  const DismissibleTaskSummaryListTile({
    super.key,
    required this.task,
    this.onDismissed,
  });

  final TaskSummary task;
  final void Function(TaskId)? onDismissed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleterControllerProvider = taskDeleterControllerProvider(task.id);
    final taskDeleterState = ref.watch(deleterControllerProvider);

    ref.listen<AsyncValue<bool>>(deleterControllerProvider, (previous, next) {
      if (next.hasError) {
        final message = next.error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), // Cancel deletion
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(true), // Confirm deletion
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        if (shouldDelete == true) {
          await ref.read(deleterControllerProvider.notifier).deleteTask();
          if (taskDeleterState.hasError) return false;
        }

        return false;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: TaskSummaryListTile(task: task),
    );
  }
}

class TaskSummaryListTile extends StatelessWidget {
  const TaskSummaryListTile({super.key, required this.task});

  final TaskSummary task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: TaskSummaryListTileCheckbox(
        taskId: task.id,
        isCompleted: task.isCompleted,
        priorityColor: task.priority.color,
      ),
      title: Text(
        task.title ?? '',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        iconSize: 16.0,
        onPressed: () => TaskDetailsRoute(task.id).push(context),
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
