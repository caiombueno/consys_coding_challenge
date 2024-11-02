import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskGetterController
    extends AutoDisposeFamilyAsyncNotifier<Task, TaskId> {
  late final TaskId taskId;

  @override
  Future<Task> build(TaskId arg) async {
    taskId = arg;

    final taskRepository = ref.read(taskRepositoryProvider);
    return await taskRepository.getTask(taskId);
  }
}

final taskGetterControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskGetterController, Task, TaskId>(TaskGetterController.new);
