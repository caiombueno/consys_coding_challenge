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

  // Load initial task summaries and add them to the BehaviorSubject
  Future<void> _updateTaskSummaries() async {
    try {
      final summaries = await _localTaskDataSource.taskSummaries;

      _taskSummariesSubject.add(summaries);
    } catch (e) {
      _taskSummariesSubject.addError(const TaskSearchException());
    }
  }

  // Expose a stream of task summaries
  Stream<List<TaskSummary>> get taskSummariesStream =>
      _taskSummariesSubject.stream;

  Future<List<Task>> get tasks async {
    try {
      return await _localTaskDataSource.tasks;
    } catch (_) {
      throw const TaskSearchException();
    }
  }

  Future<void> createTask(Task newTask) async {
    try {
      await _localTaskDataSource.createTask(newTask);
    } on DataAlreadyExistsException {
      rethrow;
    } catch (_) {
      throw const TaskCreateException();
    } finally {
      _updateTaskSummaries();
    }
  }

  Future<void> deleteTask(TaskId id) async {
    try {
      await _localTaskDataSource.deleteTask(id);
    } catch (e) {
      throw const TaskDeleteException();
    } finally {
      _updateTaskSummaries();
    }
  }

  Future<void> editTask(Task updatedTask,
      {bool shouldUpdateTaskSummaries = true}) async {
    try {
      await _localTaskDataSource.editTask(updatedTask);
    } on DataSearchException {
      throw const TaskNotFoundException();
    } catch (_) {
      throw const TaskEditException();
    } finally {
      if (shouldUpdateTaskSummaries) await _updateTaskSummaries();
    }
  }

  Future<Task> getTask(TaskId id) async {
    try {
      return await _localTaskDataSource.getTask(id);
    } catch (_) {
      throw const TaskNotFoundException();
    }
  }

  Future<void> toggleTaskComplete(TaskId id) async {
    try {
      final task = await getTask(id);

      final updatedTask = task.toggleComplete();

      await editTask(updatedTask);
    } catch (_) {
      throw const TaskEditException();
    } finally {
      await _updateTaskSummaries();
    }
  }
}

final taskRepositoryProvider = Provider.autoDispose<TaskRepository>((ref) {
  try {
    final taskSummariesSubject = BehaviorSubject<List<TaskSummary>>();
    ref.onDispose(() => taskSummariesSubject.close);

    return TaskRepository(
        ref.read(localTaskDataSourceProvider), taskSummariesSubject);
  } catch (_) {
    rethrow;
  }
});
