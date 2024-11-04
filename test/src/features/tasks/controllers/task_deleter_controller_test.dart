import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/task_deleter_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('TaskDeleterController', () {
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
        taskDeleterControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskDeleterControllerProvider(taskId).notifier);

      // Assert
      verify(() => listener(null, const AsyncData(false))).called(1);
      expect(controller.state, const AsyncData(false));
    });

    test(
        'deleteTask sets state to AsyncLoading and then AsyncData(true) on success',
        () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();

      when(() => mockTaskRepository.deleteTask(taskId))
          .thenAnswer((_) async => Future.value());

      container.listen<AsyncValue<bool>>(
        taskDeleterControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskDeleterControllerProvider(taskId).notifier);

      // Act
      await controller.deleteTask();

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

    test('deleteTask sets state to AsyncError on failure', () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();
      final exception = Exception('Failed to delete task');

      when(() => mockTaskRepository.deleteTask(taskId)).thenThrow(exception);

      container.listen<AsyncValue<bool>>(
        taskDeleterControllerProvider(taskId),
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskDeleterControllerProvider(taskId).notifier);

      // Act
      await controller.deleteTask();

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
