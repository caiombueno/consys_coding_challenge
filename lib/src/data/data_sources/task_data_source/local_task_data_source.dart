import 'package:consys_coding_challenge/src/data/data_sources/data_sources.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocalTaskDataSource extends TaskDataSource {
  static const String _tasksKey = 'tasks_key';

  final LocalStorageDataSource _localStorageDataSource;

  LocalTaskDataSource(this._localStorageDataSource);

  Future<List<Map<String, dynamic>>> get _tasksJsonList async =>
      await _localStorageDataSource.getJsonList(_tasksKey);

  @override
  Future<List<TaskSummary>> get taskSummaries async {
    try {
      final tasksJson = await _tasksJsonList;
      final List<TaskSummary> tasks =
          tasksJson.map((json) => TaskSummary.fromJson(json)).toList();

      return tasks;
    } catch (_) {
      throw const DataAccessException();
    }
  }

  Future<List<Task>> get tasks async {
    try {
      final tasksJson = await _tasksJsonList;
      final List<Task> tasks =
          tasksJson.map((json) => Task.fromJson(json)).toList();

      return tasks;
    } catch (_) {
      throw const DataAccessException();
    }
  }

  @override
  Future<void> deleteTask(TaskId id) async {
    try {
      final List<Task> tasks = await this.tasks;

      tasks.removeTask(id);

      await _localStorageDataSource.saveJsonList(_tasksKey, tasks.toJsonList());
    } on DataAccessException {
      rethrow;
    } catch (_) {
      throw const DataDeleteException();
    }
  }

  Future<void> createTask(Task newTask) async {
    try {
      final List<Task> tasks = await this.tasks;

      final taskExists = tasks.any((task) => task.id == newTask.id);
      if (taskExists) throw const DataAlreadyExistsException();

      tasks.add(newTask);
      await _localStorageDataSource.saveJsonList(_tasksKey, tasks.toJsonList());
    } on DataAlreadyExistsException {
      rethrow;
    } catch (_) {
      throw const DataSaveException();
    }
  }

  Future<void> editTask(Task updatedTask) async {
    try {
      final List<Task> tasks = await this.tasks;

      tasks.editTask(updatedTask);

      // Save the updated list to local storage
      await _localStorageDataSource.saveJsonList(_tasksKey, tasks.toJsonList());
    } on DataSearchException {
      rethrow;
    } catch (_) {
      throw const DataSaveException();
    }
  }

  Future<Task> getTask(TaskId id) async {
    try {
      final List<Task> tasks = await this.tasks;

      // Find the task with the specified ID
      final task = tasks.firstWhere(
        (task) => task.id == id,
        orElse: () => throw const DataSearchException(),
      );

      return task;
    } catch (_) {
      throw const DataSearchException();
    }
  }
}

final localTaskDataSourceProvider = Provider.autoDispose<LocalTaskDataSource>(
    (ref) => LocalTaskDataSource(ref.read(localStorageDataSourceProvider)));

extension TaskListX on List<Task> {
  List<Map<String, dynamic>> toJsonList() =>
      map((task) => task.toJson()).toList();

  void removeTask(TaskId id) {
    removeWhere((task) => task.id == id);
  }

  void editTask(Task updatedTask) {
    // Find the index of the task with the specified ID
    final index = indexWhere((task) => task.id == updatedTask.id);

    // If the task is not found, return the list as-is
    if (index == -1) throw const TaskNotFoundException();

    // Replace the task at the found index with the updated task
    this[index] = updatedTask;
  }
}
