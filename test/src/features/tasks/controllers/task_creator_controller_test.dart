import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/task_creator_controller.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('TaskCreatorController', () {
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
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();

      container.listen<AsyncValue<bool>>(
        taskCreatorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller = container.read(taskCreatorControllerProvider.notifier);

      // Assert
      verify(() => listener(null, const AsyncData(false))).called(1);
      expect(controller.state, const AsyncData(false));
    });

    test(
        'createTask sets state to AsyncLoading and then AsyncData(true) on success',
        () async {
      // Arrange
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();
      const task = Task(id: '1', title: 'New Task');

      when(() => mockTaskRepository.createTask(task))
          .thenAnswer((_) async => Future.value());

      container.listen<AsyncValue<bool>>(
        taskCreatorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller = container.read(taskCreatorControllerProvider.notifier);

      // Act
      await controller.createTask(task);

      // Assert
      verifyInOrder([
        () => listener(null, const AsyncData(false)),
        () => listener(
            any(that: isA<AsyncData>()), any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), const AsyncData(true)),
      ]);
      verifyNoMoreInteractions(listener);
      expect(controller.state, const AsyncData(true));
    });

    test('createTask sets state to AsyncError on failure', () async {
      // Arrange
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<bool>>();
      const task = Task(id: '1', title: 'New Task');
      final exception = Exception('Failed to create task');

      when(() => mockTaskRepository.createTask(task)).thenThrow(exception);

      container.listen<AsyncValue<bool>>(
        taskCreatorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller = container.read(taskCreatorControllerProvider.notifier);

      // Act
      await controller.createTask(task);

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
