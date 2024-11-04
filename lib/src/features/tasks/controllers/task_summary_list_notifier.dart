import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class TaskSummaryListNotifier extends StreamNotifier<List<TaskSummary>> {
  final BehaviorSubject<TaskSummaryListSearchQuery> searchQuerySubject =
      BehaviorSubject<TaskSummaryListSearchQuery>.seeded(
          (title: '', priority: null));

  @override
  Stream<List<TaskSummary>> build() async* {
    ref.onDispose(searchQuerySubject.close);

    final taskRepository = ref.watch(taskRepositoryProvider);

    yield* Rx.combineLatest2<List<TaskSummary>, TaskSummaryListSearchQuery,
        List<TaskSummary>>(
      taskRepository.taskSummariesStream,
      searchQuerySubject.stream,
      (taskSummaries, query) {
        return taskSummaries.where((task) {
          // Check if the title matches the query (case-insensitive)
          final matchesTitle = query.title.isEmpty ||
              (task.title?.toLowerCase().contains(query.title.toLowerCase()) ??
                  false);

          // Check if the priority matches the query, or if query.priority is null (no priority filtering)
          final matchesPriority =
              query.priority == null || task.priority == query.priority;

          // Only include tasks that match both title and priority
          return matchesTitle && matchesPriority;
        }).toList();
      },
    );
  }

  void forceRefresh() {
    final currentQuery = searchQuerySubject.value;
    searchQuerySubject
        .add(currentQuery); // Triggers a refresh with the current query
  }

  void updateTitleSearch(String title) {
    searchQuerySubject.add(
      searchQuerySubject.value.copyWith(title: title),
    );
  }

  void updatePrioritySearch(TaskPriority? priority) {
    searchQuerySubject.add(
      (title: searchQuerySubject.value.title, priority: priority),
    );
  }
}

final taskSummaryListControllerProvider =
    StreamNotifierProvider<TaskSummaryListNotifier, List<TaskSummary>>(() {
  return TaskSummaryListNotifier();
});

typedef TaskSummaryListSearchQuery = ({
  String title,
  TaskPriority? priority,
});

extension TaskSearchQueryCopyWith on TaskSummaryListSearchQuery {
  TaskSummaryListSearchQuery copyWith({
    String? title,
    TaskPriority? priority,
  }) {
    return (
      title: title ?? this.title,
      priority: priority ?? this.priority,
    );
  }
}
