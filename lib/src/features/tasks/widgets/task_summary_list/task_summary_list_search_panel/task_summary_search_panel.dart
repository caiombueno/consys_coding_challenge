import 'package:flutter/material.dart';

import 'priority_filter_dropdown.dart';
import 'task_summary_title_search_bar.dart';

class TaskSummarySearchPanel extends StatelessWidget {
  const TaskSummarySearchPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: TaskSummaryTitleSearchBar()),
          SizedBox(width: 8.0),
          PriorityFilterDropdown(),
        ],
      ),
    );
  }
}
