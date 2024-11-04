import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/task_status_toggler_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('TaskStatusTogglerController', () {
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      registerFallbackValue(const AsyncLoading<void>());
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

    test(
        'toggleTaskComplete sets state to AsyncLoading and then AsyncData(null) on success',
        () async {
      // Arrange
      const taskId = '1';
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<void>>();

      when(() => mockTaskRepository.toggleTaskComplete(taskId))
          .thenAnswer((_) async => Future.value());

      container.listen<AsyncValue<void>>(
        taskStatusTogglerControllerProvider(taskId),
        listener.call,
        fireImmediately: false,
      );

      final controller =
          container.read(taskStatusTogglerControllerProvider(taskId).notifier);

      // Act
      await controller.toggleTaskComplete();

      // Assert
      verifyInOrder([
        () => listener(
            const AsyncData<void>(null), any(that: isA<AsyncLoading>())),
        () => listener(
            any(that: isA<AsyncLoading>()), const AsyncData<void>(null)),
      ]);
      verifyNoMoreInteractions(listener);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('toggleTaskComplete sets state to AsyncError on failure', () async {
      // Arrange
      const taskId = '1';
      final exception = Exception('Failed to toggle task status');
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<void>>();

      when(() => mockTaskRepository.toggleTaskComplete(taskId))
          .thenThrow(exception);

      container.listen<AsyncValue<void>>(
        taskStatusTogglerControllerProvider(taskId),
        listener.call,
      );

      final controller =
          container.read(taskStatusTogglerControllerProvider(taskId).notifier);

      // Act
      await controller.toggleTaskComplete();

      // Assert
      verifyInOrder([
        () => listener(const AsyncData<void>(null),
            any(that: isA<AsyncLoading>())), // Initial loading state
        () => listener(any(that: isA<AsyncLoading>()),
            any(that: isA<AsyncError<void>>())), // Error state
      ]);
      expect(controller.state, isA<AsyncError<void>>());
      expect((controller.state as AsyncError).error, exception);
    });
  });
}
