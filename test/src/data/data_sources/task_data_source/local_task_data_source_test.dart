import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../../../utils/create_container.dart';

void main() {
  late MockLocalStorageDataSource mockLocalStorageDataSource;
  late LocalTaskDataSource localTaskDataSource;

  setUp(() {
    mockLocalStorageDataSource = MockLocalStorageDataSource();
    localTaskDataSource = LocalTaskDataSource(mockLocalStorageDataSource);
  });

  group('LocalTaskDataSource', () {
    const String tasksKey = 'tasks_key';

    final taskJsonList = [
      {
        'id': '1',
        'title': 'Test Task 1',
        'priority': 'none',
        'is_completed': false
      },
      {
        'id': '2',
        'title': 'Another Task',
        'priority': 'none',
        'is_completed': false
      }
    ];

    late List<TaskSummary> taskSummaries;
    late List<Task> tasks;

    setUp(() {
      taskSummaries = taskJsonList
          .map((json) => TaskSummary.fromJson(json as Map<String, dynamic>))
          .toList();

      tasks = taskJsonList
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    });

    tearDown(() {
      taskSummaries.clear();
      tasks.clear();
    });

    test('taskSummaries should return all task summaries', () async {
      // Arrange
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);

      // Act
      final result = await localTaskDataSource.taskSummaries;

      // Assert
      expect(result, taskSummaries);
    });

    test('deleteTask should remove a task by id and save updated list',
        () async {
      // Arrange
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);

      when(() => mockLocalStorageDataSource.saveJsonList(any(), any()))
          .thenAnswer((_) async {});

      final TaskId taskIdToDelete = tasks.first.id;
      final updatedTaskList = tasks..removeTask(taskIdToDelete);
      final updatedTaskListJson = updatedTaskList.toJsonList();

      // Act
      await localTaskDataSource.deleteTask(taskIdToDelete);

      // Assert
      verify(() => mockLocalStorageDataSource.saveJsonList(
          tasksKey, updatedTaskListJson)).called(1);
    });

    test('deleteTask should not fail if task id is not found', () async {
      // Arrange
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);
      when(() => mockLocalStorageDataSource.saveJsonList(any(), any()))
          .thenAnswer((_) async {});

      const TaskId taskIdToDelete = 'non_existent_id';

      // Act
      await localTaskDataSource.deleteTask(taskIdToDelete);

      // Assert
      verify(() => mockLocalStorageDataSource.saveJsonList(
          tasksKey, tasks.toJsonList())).called(1);
    });

    test('createTask should add a new task and save updated list', () async {
      // Arrange
      const newTask = Task(
        id: '3',
        title: 'New Task',
        priority: TaskPriority.low,
        isCompleted: false,
      );
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);
      when(() => mockLocalStorageDataSource.saveJsonList(any(), any()))
          .thenAnswer((_) async {});

      // Act
      await localTaskDataSource.createTask(newTask);

      // Assert
      verify(() => mockLocalStorageDataSource.saveJsonList(tasksKey, [
            ...tasks.toJsonList(),
            newTask.toJson(),
          ])).called(1);
    });

    test('createTask should throw DataAlreadyExistsException if task exists',
        () async {
      // Arrange
      const existingTask = Task(
          id: '1',
          title: 'Existing Task',
          priority: TaskPriority.none,
          isCompleted: false);
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);

      // Act & Assert
      expect(() => localTaskDataSource.createTask(existingTask),
          throwsA(isA<DataAlreadyExistsException>()));
    });

    test('editTask should update an existing task and save updated list',
        () async {
      // Arrange
      const updatedTask = Task(
          id: '1',
          title: 'Updated Task',
          priority: TaskPriority.high,
          isCompleted: true);
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);
      when(() => mockLocalStorageDataSource.saveJsonList(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await localTaskDataSource.editTask(updatedTask);

      // Assert
      verify(() => mockLocalStorageDataSource.saveJsonList(tasksKey, [
            updatedTask.toJson(),
            tasks.toJsonList()[1],
          ])).called(1);
    });

    test('getTask should return task by id if found', () async {
      // Arrange
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);
      const taskIdToFind = '1';

      // Act
      final result = await localTaskDataSource.getTask(taskIdToFind);

      // Assert
      expect(result, Task.fromJson(taskJsonList[0]));
    });

    test('getTask should throw DataSearchException if task is not found',
        () async {
      // Arrange
      when(() => mockLocalStorageDataSource.getJsonList(tasksKey))
          .thenAnswer((_) async => taskJsonList);
      const taskIdToFind = 'non_existent_id';

      // Act & Assert
      expect(() => localTaskDataSource.getTask(taskIdToFind),
          throwsA(isA<DataSearchException>()));
    });
  });

  group('localTaskDataSourceProvider', () {
    test('localTaskDataSourceProvider should return LocalTaskDataSource',
        () async {
      // Arrange
      final container = createContainer(
        overrides: [
          localStorageDataSourceProvider
              .overrideWith((ref) => mockLocalStorageDataSource),
        ],
      );

      // Act
      final localTaskDataSource = container.read(localTaskDataSourceProvider);

      // Assert
      expect(localTaskDataSource, isA<LocalTaskDataSource>());
    });
  });
}
