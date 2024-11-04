import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/task_getter_controller.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

// A generic listener class to track provider notifications
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  group('TaskGetterController', () {
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      registerFallbackValue(const AsyncLoading<Task>());
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

    test('build() retrieves and sets task data to AsyncData on success',
        () async {
      // Arrange
      const taskId = '1';
      const task = Task(id: taskId, title: 'Sample Task');
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<Task>>();

      when(() => mockTaskRepository.getTask(taskId))
          .thenAnswer((_) async => task);

      container.listen<AsyncValue<Task>>(
        taskGetterControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskGetterControllerProvider(taskId).notifier);

      // Act
      final result = await controller.build(taskId);

      // Assert
      verifyInOrder([
        () =>
            listener(null, const AsyncLoading<Task>()), // Initial loading state
        () => listener(any(that: isA<AsyncLoading<Task>>()),
            const AsyncData(task)), // Success with data
      ]);
      verifyNoMoreInteractions(listener);
      expect(result, task);
      expect(controller.state, const AsyncData(task));
    });

    test('build() throws an error directly on failure', () async {
      // Arrange
      const taskId = '1';
      final exception = Exception('Failed to retrieve task');
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<Task>>();

      when(() => mockTaskRepository.getTask(taskId)).thenThrow(exception);

      container.listen<AsyncValue<Task>>(
        taskGetterControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskGetterControllerProvider(taskId).notifier);

      // Act & Assert
      expect(() async => await controller.build(taskId), throwsA(exception));

      // Verify that the state did not change, remaining in the initial state
      verify(() => listener(null, const AsyncLoading<Task>())).called(1);
      verifyNoMoreInteractions(listener);
      expect(controller.state, const AsyncLoading<Task>());
    });
  });
}
