import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/task_summary_list_controller.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

// A generic listener class to track provider notifications
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  group('TaskSummaryListController Tests', () {
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      registerFallbackValue(const AsyncData(<TaskSummary>[]));
      registerFallbackValue(const AsyncLoading<List<TaskSummary>>());
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

    const List<TaskSummary> taskSummaries = [
      TaskSummary(id: '1', title: 'Test Task 1'),
      TaskSummary(id: '2', title: 'Another Task'),
    ];

    test('initial state is empty list', () async {
      // Arrange
      when(() => mockTaskRepository.allTaskSummaries).thenReturn(taskSummaries);
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<List<TaskSummary>>>();

      // Act
      container.listen<AsyncValue<List<TaskSummary>>>(
        taskSummaryListControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller =
          container.read(taskSummaryListControllerProvider.notifier);
      await controller.build();

      // Assert
      verifyInOrder([
        () => listener(null, const AsyncLoading<List<TaskSummary>>()),
        () => listener(const AsyncLoading<List<TaskSummary>>(),
            any(that: isA<AsyncData<List<TaskSummary>>>())),
      ]);
      verifyNoMoreInteractions(listener);

      expect(controller.state, isA<AsyncData<List<TaskSummary>>>());
      expect(controller.state.value, []);
    });

    test(
        'fetchTaskSummariesByTitle emits AsyncLoading then AsyncData on success',
        () async {
      // Arrange
      when(() => mockTaskRepository.allTaskSummaries).thenReturn(taskSummaries);

      final taskSummaryList = [taskSummaries[0]];
      when(() =>
              mockTaskRepository.getTaskSummariesByTitle(title: 'Test Task 1'))
          .thenReturn(taskSummaryList);

      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<List<TaskSummary>>>();

      // Act
      container.listen<AsyncValue<List<TaskSummary>>>(
        taskSummaryListControllerProvider,
        listener.call,
        fireImmediately: false,
      );

      final controller =
          container.read(taskSummaryListControllerProvider.notifier);
      await controller.fetchTaskSummariesByTitle(title: 'Test Task 1');

      // Assert
      verifyInOrder([
        () => listener(const AsyncLoading<List<TaskSummary>>(),
            any(that: isA<AsyncData<List<TaskSummary>>>())),
        () => listener(any(that: isA<AsyncData<List<TaskSummary>>>()),
            AsyncData<List<TaskSummary>>(taskSummaryList)),
      ]);
      verifyNoMoreInteractions(listener);
    });

    test(
        'fetchTaskSummariesByTitle emits AsyncLoading then AsyncError on failure',
        () async {
      // Arrange
      const String title = 'Test';
      when(() => mockTaskRepository.getTaskSummariesByTitle(title: title))
          .thenThrow(Exception());
      final container = makeProviderContainer(mockTaskRepository);
      final listener = Listener<AsyncValue<List<TaskSummary>>>();

      // Act
      container.listen<AsyncValue<List<TaskSummary>>>(
        taskSummaryListControllerProvider,
        listener.call,
      );

      final controller =
          container.read(taskSummaryListControllerProvider.notifier);
      await controller.fetchTaskSummariesByTitle(title: title);

      // Assert
      verifyInOrder([
        () => listener(const AsyncLoading<List<TaskSummary>>(),
            any(that: isA<AsyncData<List<TaskSummary>>>())),
        () => listener(any(that: isA<AsyncData<List<TaskSummary>>>()),
            any(that: isA<AsyncError>())),
      ]);

      verifyNoMoreInteractions(listener);

      expect(controller.state.error, isA<Exception>());
    });
  });
}
