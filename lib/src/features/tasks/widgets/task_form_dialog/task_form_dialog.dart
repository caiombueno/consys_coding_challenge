import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'state_indicators/state_indicators.dart';
import 'task_form_view/task_form_view.dart';

class TaskEditFormDialog extends HookConsumerWidget {
  const TaskEditFormDialog({
    super.key,
    required this.task,
    this.onTaskSaved,
  });
  final Task task;
  final VoidCallback? onTaskSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskEditControllerProvider = taskEditorControllerProvider(task.id);

    final taskEditControllerState = ref.watch(taskEditControllerProvider);

    final taskEditController = ref.read(taskEditControllerProvider.notifier);

    useEffect(() {
      ref.listen(taskEditControllerProvider, (prev, next) {
        if (next.asData?.value == true) {
          onTaskSaved?.call();
        }
      });
      return null;
    });

    return _RoundedDialog(
      child: taskEditControllerState.when(
        loading: () => const TaskFormLoadingIndicator(),
        // error indicator
        error: (error, stackTrace) => TaskFormErrorIndicator(
          errorMessage: error.toString(),
        ),
        data: (isTaskSaved) => isTaskSaved
            ? const TaskFormSuccessIndicator()
            : TaskFormView(
                onSubmit: (task) {
                  taskEditController.editTask(task);
                },
                task: task,
              ),
      ),
    );
  }
}

class TaskCreateFormDialog extends ConsumerWidget {
  const TaskCreateFormDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskCreatorControllerState = ref.watch(taskCreatorControllerProvider);

    final taskCreatorController =
        ref.read(taskCreatorControllerProvider.notifier);

    return _RoundedDialog(
      child: taskCreatorControllerState.when(
        loading: () => const TaskFormLoadingIndicator(),
        // error indicator
        error: (error, stackTrace) => TaskFormErrorIndicator(
          errorMessage: error.toString(),
        ),
        data: (isTaskSaved) => isTaskSaved
            ? const TaskFormSuccessIndicator()
            : TaskFormView(
                onSubmit: (task) {
                  taskCreatorController.createTask(task);
                },
              ),
      ),
    );
  }
}

class _RoundedDialog extends StatelessWidget {
  const _RoundedDialog({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
