import 'package:consys_coding_challenge/src/data/data_sources/data_sources.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocalTaskDataSource extends TaskDataSource {
  static const String _tasksKey = 'tasks_key';

  final LocalStorageDataSource _localStorageDataSource;

  const LocalTaskDataSource(this._localStorageDataSource);

  List<dynamic> get _tasksJson =>
      _localStorageDataSource.getJson(_tasksKey)['tasks'];

  List<TaskSummary> get allTaskSummaries => getTaskSummariesByTitle();

  @override
  List<TaskSummary> getTaskSummariesByTitle({String? title}) {
    final List<TaskSummary> tasks = _tasksJson
        .map((json) => TaskSummary.fromJson(json as Map<String, dynamic>))
        .toList();

    if (title == null || title.isEmpty) return tasks;

    return tasks
        .where((task) =>
            task.title != null &&
            task.title!.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  @override
  void deleteTask(TaskId id) {
    final List<TaskSummary> tasks = allTaskSummaries;

    tasks.removeWhere((task) => task.id == id);

    _localStorageDataSource.saveJson(_tasksKey, tasks.toJson());
  }
}

final localTaskDataSourceProvider =
    Provider.autoDispose<LocalTaskDataSource>((ref) {
  final localStorageDataSourceState = ref.read(localStorageDataSourceProvider);

  final localStorageDataSource = localStorageDataSourceState.value;

  if (localStorageDataSourceState.hasError || localStorageDataSource == null) {
    throw const InitializationException();
  }

  return LocalTaskDataSource(localStorageDataSource);
});

extension on List<TaskSummary> {
  Map<String, dynamic> toJson() =>
      {'tasks': map((task) => task.toJson()).toList()};
}
