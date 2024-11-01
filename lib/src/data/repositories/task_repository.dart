import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

class TaskRepository {
  final LocalTaskDataSource _localTaskDataSource;

  final BehaviorSubject<List<TaskSummary>> _taskSummariesSubject;

  TaskRepository(this._localTaskDataSource, this._taskSummariesSubject) {
    _updateTaskSummaries();
  }

  // void dispose() => _taskSummariesSubject.close();

  // Load initial task summaries and add them to the BehaviorSubject
  void _updateTaskSummaries() {
    try {
      final summaries = _localTaskDataSource.taskSummaries;
      _taskSummariesSubject.add(summaries);
    } catch (e) {
      _taskSummariesSubject.addError(const TaskSearchException());
    }
  }

  // Expose a stream of task summaries
  Stream<List<TaskSummary>> get taskSummariesStream =>
      _taskSummariesSubject.stream;

  void deleteTask(TaskId id) {
    try {
      _localTaskDataSource.deleteTask(id);

      _updateTaskSummaries();
    } catch (e) {
      throw const TaskDeleteException();
    }
  }
}

final taskRepositoryProvider =
    FutureProvider.autoDispose<TaskRepository>((ref) async {
  try {
    final taskSummariesSubject = BehaviorSubject<List<TaskSummary>>();
    ref.onDispose(() => taskSummariesSubject.close);

    final localTaskDataSource =
        await ref.read(localTaskDataSourceProvider.future);

    final repository =
        TaskRepository(localTaskDataSource, taskSummariesSubject);

    return repository;
  } catch (_) {
    rethrow;
  }
});
