import 'package:consys_coding_challenge/src/features/tasks/tasks.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
