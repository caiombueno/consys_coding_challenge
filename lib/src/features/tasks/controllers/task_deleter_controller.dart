import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskDeleterController
    extends AutoDisposeFamilyAsyncNotifier<bool, TaskId> {
  late final TaskId taskId;

  @override
  FutureOr<bool> build(TaskId arg) {
    taskId = arg;
    return false;
  }

  Future<void> deleteTask() async {
    state = const AsyncLoading();
    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.deleteTask(taskId);
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskDeleterControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskDeleterController, bool, TaskId>(TaskDeleterController.new);
