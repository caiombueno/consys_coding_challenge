import 'package:flutter/material.dart';

class TaskSummaryListViewEmptyIndicator extends StatelessWidget {
  const TaskSummaryListViewEmptyIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No tasks found.'),
    );
  }
}
