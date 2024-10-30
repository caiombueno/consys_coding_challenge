import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockLocalStorageDataSource mockLocalStorageDataSource;
  late LocalTaskDataSource localTaskDataSource;

  setUp(() {
    mockLocalStorageDataSource = MockLocalStorageDataSource();
    localTaskDataSource = LocalTaskDataSource(mockLocalStorageDataSource);
  });

  group('LocalTaskDataSource', () {
    const String tasksKey = 'tasks_key';

    final taskJson = [
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
    final List<TaskSummary> taskSummaries = taskJson
        .map((json) => TaskSummary.fromJson(json as Map<String, dynamic>))
        .toList();

    test('allTaskSummaries should return all task summaries', () {
      // Arrange
      when(() => mockLocalStorageDataSource.getJson(tasksKey))
          .thenReturn({'tasks': taskJson});

      // Act
      final result = localTaskDataSource.allTaskSummaries;

      // Assert
      expect(result, taskSummaries);
    });

    test(
        'getTaskSummariesByTitle should return filtered task summaries by title',
        () {
      // Arrange
      when(() => mockLocalStorageDataSource.getJson(tasksKey))
          .thenReturn({'tasks': taskJson});
      const title = 'Test';

      // Act
      final result = localTaskDataSource.getTaskSummariesByTitle(title: title);

      // Assert
      expect(result, [taskSummaries.first]);
    });

    test('getTaskSummariesByTitle should return all tasks if title is null',
        () {
      // Arrange
      when(() => mockLocalStorageDataSource.getJson(tasksKey))
          .thenReturn({'tasks': taskJson});

      // Act
      final result = localTaskDataSource.getTaskSummariesByTitle();

      // Assert
      expect(result, taskSummaries);
    });

    test('deleteTask should remove a task by id and save updated list', () {
      // Arrange
      when(() => mockLocalStorageDataSource.getJson(tasksKey))
          .thenReturn({'tasks': taskJson});
      when(() => mockLocalStorageDataSource.saveJson(any(), any()))
          .thenAnswer((_) async => true);

      const TaskId taskIdToDelete = '1';
      final updatedTaskListJson = {
        'tasks': [taskSummaries[1].toJson()]
      };

      // Act
      localTaskDataSource.deleteTask(taskIdToDelete);

      // Assert
      verify(() => mockLocalStorageDataSource.saveJson(
          tasksKey, updatedTaskListJson)).called(1);
    });

    test('deleteTask should not fail if task id is not found', () {
      // Arrange
      when(() => mockLocalStorageDataSource.getJson(tasksKey))
          .thenReturn({'tasks': taskJson});
      when(() => mockLocalStorageDataSource.saveJson(any(), any()))
          .thenAnswer((_) async => true);

      const TaskId taskIdToDelete = 'non_existent_id';

      // Act
      localTaskDataSource.deleteTask(taskIdToDelete);

      // Assert
      verify(() => mockLocalStorageDataSource
          .saveJson(tasksKey, {'tasks': taskJson})).called(1);
    });
  });
}
