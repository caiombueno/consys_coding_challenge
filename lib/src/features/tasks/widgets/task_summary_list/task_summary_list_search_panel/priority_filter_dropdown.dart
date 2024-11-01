import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PriorityFilterDropdown extends HookConsumerWidget {
  const PriorityFilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priority = useState<TaskPriority?>(null);

    final taskSummaryListController =
        ref.read(taskSummaryListControllerProvider.notifier);

    void updatePriority(TaskPriority? newPriority) {
      priority.value = newPriority;
      taskSummaryListController.updatePrioritySearch(newPriority);
    }

    return _PriorityDropdown(
      selectedPriority: priority.value,
      onChanged: updatePriority,
    );
  }
}

class _PriorityDropdown extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final ValueChanged<TaskPriority?> onChanged;

  const _PriorityDropdown({
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TaskPriority?>(
      value: selectedPriority,
      underline: Container(), // Hide underline for a cleaner look
      onChanged: onChanged, // Allow null selection for "No Priority"
      items: [
        const DropdownMenuItem<TaskPriority?>(
          value: null,
          child: Text("All Priorities"),
        ),
        ...TaskPriority.values.map((priority) {
          return DropdownMenuItem<TaskPriority?>(
            value: priority,
            child: Text(priority.name),
          );
        }),
      ],
    );
  }
}
