import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskEditorController
    extends AutoDisposeFamilyAsyncNotifier<bool, TaskId> {
  @override
  FutureOr<bool> build(TaskId arg) => false;

  Future<void> editTask(Task task) async {
    state = const AsyncLoading();
    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.editTask(task);
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskEditorControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskEditorController, bool, TaskId>(TaskEditorController.new);
