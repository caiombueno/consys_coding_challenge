import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/task_editor_controller.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('TaskEditorController', () {
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      registerFallbackValue(const AsyncData(false));
      registerFallbackValue(const AsyncLoading<bool>());
    });

    setUp(() {
      mockTaskRepository = MockTaskRepository();
    });

    ProviderContainer makeProviderContainer(MockTaskRepository taskRepository) {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWith((ref) => taskRepository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('initial state is AsyncData(false)', () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();

      container.listen<AsyncValue<bool>>(
        taskEditorControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskEditorControllerProvider(taskId).notifier);

      // Assert
      verify(() => listener(null, const AsyncData(false))).called(1);
      expect(controller.state, const AsyncData(false));
    });

    test(
        'editTask sets state to AsyncLoading and then AsyncData(true) on success',
        () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();
      const task = Task(
        id: taskId,
        title: 'Updated Task',
      );

      when(() => mockTaskRepository.editTask(task))
          .thenAnswer((_) async => Future.value());

      container.listen<AsyncValue<bool>>(
        taskEditorControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskEditorControllerProvider(taskId).notifier);

      // Act
      await controller.editTask(task);

      // Assert
      verifyInOrder([
        () => listener(null, const AsyncData(false)), // Initial state
        () => listener(any(that: isA<AsyncData>()),
            any(that: isA<AsyncLoading>())), // Loading
        () => listener(
            any(that: isA<AsyncLoading>()), const AsyncData(true)), // Success
      ]);
      verifyNoMoreInteractions(listener);
      expect(controller.state, const AsyncData(true));
    });

    test('editTask sets state to AsyncError on failure', () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();
      const task = Task(id: taskId, title: 'Updated Task');
      final exception = Exception('Failed to edit task');

      when(() => mockTaskRepository.editTask(task)).thenThrow(exception);

      container.listen<AsyncValue<bool>>(
        taskEditorControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskEditorControllerProvider(taskId).notifier);

      // Act
      await controller.editTask(task);

      // Assert
      verifyInOrder([
        () => listener(null, const AsyncData(false)), // Initial state
        () => listener(any(that: isA<AsyncData>()),
            any(that: isA<AsyncLoading>())), // Loading
        () => listener(any(that: isA<AsyncLoading>()),
            any(that: isA<AsyncError>())), // Error
      ]);
      expect(controller.state, isA<AsyncError>());
      expect((controller.state as AsyncError).error, exception);
    });
  });
}
