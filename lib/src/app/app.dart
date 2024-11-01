import 'package:consys_coding_challenge/src/features/tasks/widgets/task_summary_list/task_summary_list_search_panel/task_summary_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/widgets.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: const SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TaskSummarySearchPanel(),
              Expanded(child: TaskSummaryListView()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
