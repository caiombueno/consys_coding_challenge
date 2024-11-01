import 'package:consys_coding_challenge/src/data/data_sources/data_sources.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocalTaskDataSource extends TaskDataSource {
  static const String _tasksKey = 'tasks_key';

  final LocalStorageDataSource _localStorageDataSource;

  LocalTaskDataSource(this._localStorageDataSource) {
    final tasks = [
      const TaskSummary(
          id: '1', title: 'Test Task 1', priority: TaskPriority.high),
      const TaskSummary(
          id: '2', title: 'Another Task', priority: TaskPriority.medium),
    ];

    final tasksJson = tasks.toJson();
    _localStorageDataSource.saveJson(_tasksKey, tasksJson);
  }

  List<dynamic> get _tasksJson =>
      _localStorageDataSource.getJson(_tasksKey)['tasks'];

  @override
  List<TaskSummary> get taskSummaries {
    try {
      final List<TaskSummary> tasks = _tasksJson
          .map((json) => TaskSummary.fromJson(json as Map<String, dynamic>))
          .toList();

      return tasks;
    } catch (_) {
      throw const DataAccessException();
    }
  }

  @override
  void deleteTask(TaskId id) {
    try {
      final List<TaskSummary> tasks = taskSummaries;

      tasks.removeWhere((task) => task.id == id);

      _localStorageDataSource.saveJson(_tasksKey, tasks.toJson());
    } on DataAccessException {
      rethrow;
    } catch (_) {
      throw const DataDeleteException();
    }
  }
}

final localTaskDataSourceProvider =
    FutureProvider.autoDispose<LocalTaskDataSource>((ref) async {
  try {
    final localStorageDataSource =
        await ref.read(localStorageDataSourceProvider.future);

    return LocalTaskDataSource(localStorageDataSource);
  } catch (_) {
    rethrow;
  }
});

extension on List<TaskSummary> {
  Map<String, dynamic> toJson() =>
      {'tasks': map((task) => task.toJson()).toList()};
}
