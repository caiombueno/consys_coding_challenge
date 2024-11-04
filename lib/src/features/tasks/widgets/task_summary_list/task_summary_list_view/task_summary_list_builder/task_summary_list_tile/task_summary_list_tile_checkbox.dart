import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:consys_coding_challenge/src/utils/async_value_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskSummaryListTileCheckbox extends HookConsumerWidget {
  const TaskSummaryListTileCheckbox({
    super.key,
    required this.isCompleted,
    required this.taskId,
    required this.priorityColor,
  });
  final bool isCompleted;
  final TaskId taskId;
  final int priorityColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusTogglerProvider = taskStatusTogglerControllerProvider(taskId);

    final statusToggler = ref.read(statusTogglerProvider.notifier);

    final statusTogglerState = ref.watch(statusTogglerProvider);

    useEffect(() {
      if (statusTogglerState.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final message = statusTogglerState.errorMessage;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
      return null;
    });

    return Checkbox(
      value: isCompleted,
      onChanged: (selected) {
        statusToggler.toggleTaskComplete();
      },
      fillColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF9E9E9E);
        }
        return null;
      }),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          width: 2.0,
          color: (!states.contains(WidgetState.selected))
              ? Color(priorityColor)
              : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}
