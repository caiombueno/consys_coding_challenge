import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskCreatorController extends AutoDisposeAsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> createTask(Task task) async {
    state = const AsyncLoading();
    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.createTask(task);
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskCreatorControllerProvider =
    AsyncNotifierProvider.autoDispose<TaskCreatorController, bool>(
        () => TaskCreatorController());
