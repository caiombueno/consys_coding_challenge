import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

void main() {
  group('TaskSummary', () {
    const String taskId = '123';
    const String taskTitle = 'Test Task';
    const TaskPriority taskPriority = TaskPriority.high;
    const bool isCompleted = true;

    const taskSummary = TaskSummary(
      id: taskId,
      title: taskTitle,
      priority: taskPriority,
      isCompleted: isCompleted,
    );

    test('supports value equality', () {
      // Act & Assert
      expect(
        taskSummary,
        const TaskSummary(
          id: taskId,
          title: taskTitle,
          priority: taskPriority,
          isCompleted: isCompleted,
        ),
      );
    });

    test('props are correct', () {
      // Act
      final props = taskSummary.props;

      // Assert
      expect(props, [taskId, taskTitle, taskPriority, isCompleted]);
    });

    test('serialization and deserialization work correctly', () {
      // Act
      final json = taskSummary.toJson();
      final deserializedTask = TaskSummary.fromJson(json);

      // Assert
      expect(json, {
        'id': taskId,
        'title': taskTitle,
        'priority': 'high',
        'isCompleted': isCompleted,
      });
      expect(deserializedTask, taskSummary);
    });

    test('default values are set correctly', () {
      // Arrange
      const taskSummaryWithDefaults = TaskSummary(id: taskId);

      // Act & Assert
      expect(taskSummaryWithDefaults.title, isNull);
      expect(taskSummaryWithDefaults.priority, TaskPriority.none);
      expect(taskSummaryWithDefaults.isCompleted, false);
    });

    group('fromJson', () {
      test('fromJson sets default values when fields are missing', () {
        // Arrange
        final json = {'id': taskId};

        // Act
        final taskSummaryFromJson = TaskSummary.fromJson(json);

        // Assert
        expect(taskSummaryFromJson.id, taskId);
        expect(taskSummaryFromJson.title, isNull);
        expect(taskSummaryFromJson.priority, TaskPriority.none);
        expect(taskSummaryFromJson.isCompleted, false);
      });

      test('fromJson throws exception if id is null', () {
        // Arrange
        final json = {
          'title': taskTitle,
          'priority': 'high',
          'isCompleted': isCompleted,
        };

        // Act & Assert
        expect(
          () => TaskSummary.fromJson(json),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('toJson', () {
      test('toJson includes all non-null fields', () {
        // Arrange
        const taskSummaryWithNulls = TaskSummary(
          id: taskId,
          priority: TaskPriority.none,
          isCompleted: false,
        );

        // Act
        final json = taskSummaryWithNulls.toJson();

        // Assert
        expect(json, {
          'id': taskId,
          'title': null,
          'priority': 'none',
          'isCompleted': false,
        });
      });
    });
  });
}
