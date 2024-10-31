import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import '../../../utils/create_container.dart';

class MockLocalTaskDataSource extends Mock implements LocalTaskDataSource {}

void main() {
  late MockLocalTaskDataSource mockLocalTaskDataSource;
  late TaskRepository taskRepository;

  setUp(() {
    mockLocalTaskDataSource = MockLocalTaskDataSource();
    taskRepository = TaskRepository(mockLocalTaskDataSource);
  });

  group('TaskRepository', () {
    const List<TaskSummary> taskSummaries = [
      TaskSummary(id: '1', title: 'Test Task 1'),
      TaskSummary(id: '2', title: 'Another Task'),
    ];

    test('allTaskSummaries returns all task summaries', () {
      // Arrange
      when(() => mockLocalTaskDataSource.allTaskSummaries)
          .thenReturn(taskSummaries);

      // Act
      final result = taskRepository.allTaskSummaries;

      // Assert
      expect(result, taskSummaries);
      verify(() => mockLocalTaskDataSource.allTaskSummaries).called(1);
    });

    test('getAllTasks throws TaskSearchException when an error occurs', () {
      // Arrange
      when(() => mockLocalTaskDataSource.allTaskSummaries)
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.allTaskSummaries,
          throwsA(isA<TaskSearchException>()));
      verify(() => mockLocalTaskDataSource.allTaskSummaries).called(1);
    });

    test('getTasksByTitle returns filtered task summaries by title', () {
      // Arrange
      const String title = 'Test';
      when(() => mockLocalTaskDataSource.getTaskSummariesByTitle(title: title))
          .thenReturn([taskSummaries[0]]);

      // Act
      final result = taskRepository.getTaskSummariesByTitle(title: title);

      // Assert
      expect(result, [taskSummaries[0]]);
      verify(() =>
              mockLocalTaskDataSource.getTaskSummariesByTitle(title: title))
          .called(1);
    });

    test('getTasksByTitle throws TaskSearchException when an error occurs',
        () async {
      // Arrange
      const String title = 'Test';
      when(() => mockLocalTaskDataSource.getTaskSummariesByTitle(title: title))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.getTaskSummariesByTitle(title: title),
          throwsA(isA<TaskSearchException>()));
      verify(() =>
              mockLocalTaskDataSource.getTaskSummariesByTitle(title: title))
          .called(1);
    });

    test('deleteTask successfully deletes a task by ID', () {
      // Arrange
      const TaskId taskId = '1';
      when(() => mockLocalTaskDataSource.deleteTask(taskId))
          .thenAnswer((_) async => Future.value());

      // Act
      taskRepository.deleteTask(taskId);

      // Assert
      verify(() => mockLocalTaskDataSource.deleteTask(taskId)).called(1);
    });

    test('deleteTask throws TaskDeleteException when an error occurs', () {
      // Arrange
      const TaskId taskId = '1';
      when(() => mockLocalTaskDataSource.deleteTask(taskId))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.deleteTask(taskId),
          throwsA(isA<TaskDeleteException>()));
      verify(() => mockLocalTaskDataSource.deleteTask(taskId)).called(1);
    });
  });

  group('taskRepositoryProvider', () {
    test('taskRepositoryProvider returns TaskRepository', () async {
      // Arrange
      final container = createContainer(overrides: [
        localTaskDataSourceProvider
            .overrideWith((ref) => mockLocalTaskDataSource),
      ]);

      // Act
      final taskRepository =
          await container.read(taskRepositoryProvider.future);

      // Assert
      expect(taskRepository, isA<TaskRepository>());
    });

    test(
        'taskRepositoryProvider rethrows exception if localTaskDataSourceProvider fails',
        () async {
      // Arrange
      final container = createContainer(overrides: [
        localTaskDataSourceProvider
            .overrideWith((ref) => throw Exception("Initialization error")),
      ]);

      // Act & Assert
      expect(
        () => container.read(taskRepositoryProvider.future),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains("Initialization error"))),
      );
    });
  });
}
