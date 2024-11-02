import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'task_summary_list_builder/task_summary_list_builder.dart';
import 'task_summary_list_view_empty_indicator.dart';
import 'task_summary_list_view_error_indicator.dart';
import 'task_summary_list_view_loading_indicator.dart';

class TaskSummaryListView extends HookConsumerWidget {
  const TaskSummaryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskSummaryControllerState =
        ref.watch(taskSummaryListControllerProvider);

    return taskSummaryControllerState.when(
      data: (taskSummaries) {
        if (taskSummaries.isEmpty) {
          return const TaskSummaryListViewEmptyIndicator();
        }

        return TaskSummaryListBuilder(
            key: ValueKey(taskSummaries), taskSummaries: taskSummaries);
      },
      loading: () => const TaskSummaryListViewLoadingIndicator(),
      error: (error, stackTrace) =>
          TaskSummaryListViewErrorIndicator(error: error),
    );
  }
}
