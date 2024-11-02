import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskEditorController extends AutoDisposeFamilyAsyncNotifier<void, Task> {
  late final Task task;

  @override
  FutureOr build(Task arg) {
    task = arg;
  }

  Future<void> editTask() async {
    state = const AsyncLoading();
    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.editTask(task);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskEditorControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskEditorController, void, Task>(TaskEditorController.new);
