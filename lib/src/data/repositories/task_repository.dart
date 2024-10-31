import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskRepository {
  final LocalTaskDataSource _localTaskDataSource;

  const TaskRepository(this._localTaskDataSource);

  List<TaskSummary> get allTaskSummaries => getTaskSummariesByTitle();

  List<TaskSummary> getTaskSummariesByTitle({String? title}) {
    try {
      return _localTaskDataSource.getTaskSummariesByTitle(title: title);
    } catch (e) {
      throw const TaskSearchException();
    }
  }

  void deleteTask(TaskId id) {
    try {
      _localTaskDataSource.deleteTask(id);
    } catch (e) {
      throw const TaskDeleteException();
    }
  }
}

final taskRepositoryProvider =
    FutureProvider.autoDispose<TaskRepository>((ref) async {
  try {
    final localTaskDataSource =
        await ref.read(localTaskDataSourceProvider.future);

    return TaskRepository(localTaskDataSource);
  } catch (_) {
    rethrow;
  }
});
