import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/features/tasks/tasks.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/task_summary_list/task_summary_list_view/task_summary_list_builder/task_summary_list_builder.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/task_summary_list/task_summary_list_view/task_summary_list_view_empty_indicator.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/task_summary_list/task_summary_list_view/task_summary_list_view_error_indicator.dart';
import 'package:consys_coding_challenge/src/features/tasks/widgets/task_summary_list/task_summary_list_view/task_summary_list_view_loading_indicator.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

import '../../../../../../mocks.dart';

void main() {
  group('TaskSummaryListView Tests', () {
    late MockTaskSummaryListNotifier mockTaskSummaryListNotifier;

    setUp(() {
      mockTaskSummaryListNotifier = MockTaskSummaryListNotifier();
    });

    Future<void> pumpTaskSummaryListView(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskSummaryListControllerProvider
                .overrideWith(() => mockTaskSummaryListNotifier),
          ],
          child: const MaterialApp(
            home: Scaffold(body: TaskSummaryListView()),
          ),
        ),
      );
    }

    testWidgets('displays loading indicator when data is loading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockTaskSummaryListNotifier.build())
          .thenAnswer((_) => const Stream<List<TaskSummary>>.empty());

      // Act
      await pumpTaskSummaryListView(tester);

      // Assert
      expect(find.byType(TaskSummaryListViewLoadingIndicator), findsOneWidget);
    });

    testWidgets('displays error indicator when an error occurs',
        (WidgetTester tester) async {
      // Arrange
      final exception = Exception('Failed to load task summaries');

      when(() => mockTaskSummaryListNotifier.build())
          .thenAnswer((_) => Stream<List<TaskSummary>>.error(exception));

      // Act
      await pumpTaskSummaryListView(tester);

      await tester.pump();

      // Assert
      expect(find.byType(TaskSummaryListViewErrorIndicator), findsOneWidget);
    });

    testWidgets('displays empty indicator when taskSummaries list is empty',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockTaskSummaryListNotifier.build()).thenAnswer(
          (_) => Stream.value([])); // Empty list for empty indicator

      // Act
      await pumpTaskSummaryListView(tester);

      await tester.pump();

      // Assert
      expect(find.byType(TaskSummaryListViewEmptyIndicator), findsOneWidget);
    });

    testWidgets('displays task summaries when data is loaded',
        (WidgetTester tester) async {
      // Arrange
      final taskSummaries = [
        const TaskSummary(
            id: '1', title: 'Task 1', priority: TaskPriority.medium),
        const TaskSummary(
            id: '2', title: 'Task 2', priority: TaskPriority.high),
      ];
      when(() => mockTaskSummaryListNotifier.build())
          .thenAnswer((_) => Stream.value(taskSummaries));

      // Act
      await pumpTaskSummaryListView(tester);

      await tester.pump();

      // Assert
      expect(find.byType(TaskSummaryListBuilder), findsOneWidget);
      expect(find.byKey(ValueKey(taskSummaries)), findsOneWidget);
    });
  });
}
