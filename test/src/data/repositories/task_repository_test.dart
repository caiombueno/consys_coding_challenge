import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mocks.dart';
import '../../../utils/create_container.dart';

class StubGetterMockLocalTaskDataSource extends MockLocalStorageDataSource {
  final List<TaskSummary> taskSummariesStubber;
  StubGetterMockLocalTaskDataSource({this.taskSummariesStubber = const []});

  Future<List<TaskSummary>> get taskSummaries async {
    return taskSummariesStubber;
  }
}

void main() {
  late MockLocalTaskDataSource mockLocalTaskDataSource;
  late BehaviorSubject<List<TaskSummary>> taskSummariesSubject;
  late TaskRepository taskRepository;

  setUpAll(() {
    registerFallbackValue(const Task(id: 'id'));
  });

  setUp(() {
    mockLocalTaskDataSource = MockLocalTaskDataSource();
    taskSummariesSubject = BehaviorSubject<List<TaskSummary>>();
    taskRepository = TaskRepository(
      mockLocalTaskDataSource,
      taskSummariesSubject,
      loadInitialData: false,
    );
  });

  tearDown(() {
    taskSummariesSubject.close();
  });

  group('TaskRepository', () {
    final List<TaskSummary> taskSummaries = [
      const TaskSummary(id: '1', title: 'Test Task 1'),
      const TaskSummary(id: '2', title: 'Another Task'),
    ];
    final List<Task> tasks = [
      const Task(id: '1', title: 'Test Task 1'),
      const Task(id: '2', title: 'Another Task'),
    ];

    test(
        'taskSummariesStream emits updated task summaries when a task is created',
        () async {
      // Arrange
      when(() => mockLocalTaskDataSource.taskSummaries)
          .thenAnswer((_) async => taskSummaries);

      when(() => mockLocalTaskDataSource.createTask(any()))
          .thenAnswer((_) async {});

      // Act
      await taskRepository.createTask(tasks[0]);

      // Assert
      expect(
        taskRepository.taskSummariesStream,
        emits(taskSummaries),
      );
    });

    test('tasks returns list of tasks', () async {
      // Arrange
      when(() => mockLocalTaskDataSource.tasks).thenAnswer((_) async => tasks);

      // Act
      final result = await taskRepository.tasks;

      // Assert
      expect(result, tasks);
    });

    test('tasks throws TaskSearchException when an error occurs', () async {
      // Arrange
      when(() => mockLocalTaskDataSource.tasks).thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.tasks, throwsA(isA<TaskSearchException>()));
    });

    test('createTask calls LocalTaskDataSource to create a new task', () async {
      // Arrange
      const newTask = Task(
          id: '3',
          title: 'New Task',
          priority: TaskPriority.low,
          isCompleted: false);
      when(() => mockLocalTaskDataSource.createTask(newTask))
          .thenAnswer((_) async => Future.value());

      // Act
      await taskRepository.createTask(newTask);

      // Assert
      verify(() => mockLocalTaskDataSource.createTask(newTask)).called(1);
    });

    test('createTask throws TaskCreateException when an error occurs',
        () async {
      // Arrange
      const newTask = Task(
          id: '3',
          title: 'New Task',
          priority: TaskPriority.low,
          isCompleted: false);
      when(() => mockLocalTaskDataSource.createTask(newTask))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.createTask(newTask),
          throwsA(isA<TaskCreateException>()));
    });

    test('deleteTask calls LocalTaskDataSource to delete a task by ID',
        () async {
      // Arrange
      const TaskId taskId = '1';
      when(() => mockLocalTaskDataSource.deleteTask(taskId))
          .thenAnswer((_) async => Future.value());

      // Act
      await taskRepository.deleteTask(taskId);

      // Assert
      verify(() => mockLocalTaskDataSource.deleteTask(taskId)).called(1);
    });

    test('deleteTask throws TaskDeleteException when an error occurs',
        () async {
      // Arrange
      const TaskId taskId = '1';
      when(() => mockLocalTaskDataSource.deleteTask(taskId))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.deleteTask(taskId),
          throwsA(isA<TaskDeleteException>()));
    });

    test('editTask calls LocalTaskDataSource to update an existing task',
        () async {
      // Arrange
      const updatedTask = Task(
          id: '1',
          title: 'Updated Task',
          priority: TaskPriority.high,
          isCompleted: true);
      when(() => mockLocalTaskDataSource.editTask(updatedTask))
          .thenAnswer((_) async => Future.value());

      // Act
      await taskRepository.editTask(updatedTask);

      // Assert
      verify(() => mockLocalTaskDataSource.editTask(updatedTask)).called(1);
    });

    test('editTask throws TaskEditException when an error occurs', () async {
      // Arrange
      const updatedTask = Task(
          id: '1',
          title: 'Updated Task',
          priority: TaskPriority.high,
          isCompleted: true);
      when(() => mockLocalTaskDataSource.editTask(updatedTask))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.editTask(updatedTask),
          throwsA(isA<TaskEditException>()));
    });

    test('getTask calls LocalTaskDataSource to retrieve a task by ID',
        () async {
      // Arrange
      const TaskId taskId = '1';
      final task = tasks[0];
      when(() => mockLocalTaskDataSource.getTask(taskId))
          .thenAnswer((_) async => task);

      // Act
      final result = await taskRepository.getTask(taskId);

      // Assert
      expect(result, task);
    });

    test('getTask throws TaskNotFoundException if task is not found', () async {
      // Arrange
      const TaskId taskId = 'non_existent_id';
      when(() => mockLocalTaskDataSource.getTask(taskId))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.getTask(taskId),
          throwsA(isA<TaskNotFoundException>()));
    });

    test('toggleTaskComplete calls editTask', () async {
      // Arrange
      const task = Task(id: '1', title: 'Test Task');
      final TaskId taskId = task.id;

      when(() => mockLocalTaskDataSource.getTask(any()))
          .thenAnswer((_) async => task);
      when(() => mockLocalTaskDataSource.editTask(any()))
          .thenAnswer((_) async {});

      // Act
      await taskRepository.toggleTaskComplete(taskId);

      // Assert
      verify(() => mockLocalTaskDataSource.editTask(any<Task>())).called(1);
    });

    test('toggleTaskComplete throws TaskEditException if an error occurs',
        () async {
      // Arrange
      const TaskId taskId = '1';
      when(() => mockLocalTaskDataSource.getTask(taskId))
          .thenThrow(Exception());

      // Act & Assert
      expect(() => taskRepository.toggleTaskComplete(taskId),
          throwsA(isA<TaskEditException>()));
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
      final taskRepository = container.read(taskRepositoryProvider);

      // Assert
      expect(taskRepository, isA<TaskRepository>());
    });
  });
}
