import 'package:flutter/material.dart';

class TaskSummaryListViewLoadingIndicator extends StatelessWidget {
  const TaskSummaryListViewLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
