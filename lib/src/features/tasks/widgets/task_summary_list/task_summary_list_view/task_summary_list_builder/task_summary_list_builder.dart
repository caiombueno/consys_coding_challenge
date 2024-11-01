import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';

import 'task_summary_list_tile.dart';

class TaskSummaryListBuilder extends StatelessWidget {
  const TaskSummaryListBuilder({
    super.key,
    required this.taskSummaries,
  });
  final List<TaskSummary> taskSummaries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskSummaries.length,
      itemBuilder: (_, index) =>
          TaskSummaryListTile(task: taskSummaries[index]),
    );
  }
}
