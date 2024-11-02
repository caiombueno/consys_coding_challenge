import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskStatusTogglerController
    extends AutoDisposeFamilyAsyncNotifier<void, TaskId> {
  late final TaskId taskId;

  @override
  FutureOr build(TaskId arg) {
    taskId = arg;
  }

  Future<void> toggleTaskComplete() async {
    state = const AsyncLoading();
    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.toggleTaskComplete(taskId);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskStatusTogglerControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskStatusTogglerController, void, TaskId>(
        TaskStatusTogglerController.new);
