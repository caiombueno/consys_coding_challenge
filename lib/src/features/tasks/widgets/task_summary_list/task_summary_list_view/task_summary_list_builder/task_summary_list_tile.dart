import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';

class TaskSummaryListTile extends StatelessWidget {
  const TaskSummaryListTile({super.key, required this.task, this.onChanged});

  final TaskSummary task;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Removes default padding
      leading: Checkbox(
          value: task.isCompleted,
          onChanged: (selected) {},
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: 2.0,
              color: (!states.contains(WidgetState.selected))
                  ? Color(task.priority.color)
                  : const Color(0xFF9E9E9E),
            ),
          )),
      title: Text(
        task.title ?? '',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
