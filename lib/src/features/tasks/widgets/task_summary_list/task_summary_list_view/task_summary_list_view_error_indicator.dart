import 'package:flutter/material.dart';

class TaskSummaryListViewErrorIndicator extends StatelessWidget {
  const TaskSummaryListViewErrorIndicator({
    super.key,
    required this.error,
  });
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('An error occurred: $error'),
    );
  }
}
