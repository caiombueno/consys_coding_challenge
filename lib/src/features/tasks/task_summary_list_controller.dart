import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskSummaryListController
    extends AutoDisposeAsyncNotifier<List<TaskSummary>> {
  Future<TaskRepository> get _taskRepository async {
    try {
      final taskRepository = await ref.read(taskRepositoryProvider.future);

      return taskRepository;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<TaskSummary>> build() async => [];

  Future<void> fetchTaskSummariesByTitle({String? title}) async {
    state = const AsyncLoading();

    try {
      final taskRepository = await _taskRepository;
      final tasks = taskRepository.getTaskSummariesByTitle(title: title);
      state = AsyncValue.data(tasks); // Emit success state with data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final taskSummaryListControllerProvider = AsyncNotifierProvider.autoDispose<
    TaskSummaryListController,
    List<TaskSummary>>(() => TaskSummaryListController());
