import 'dart:async';

import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskGetterController
    extends AutoDisposeFamilyAsyncNotifier<Task, TaskId> {
  @override
  Future<Task> build(TaskId arg) async {
    final taskRepository = ref.read(taskRepositoryProvider);
    return await taskRepository.getTask(arg);
  }
}

final taskGetterControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TaskGetterController, Task, TaskId>(TaskGetterController.new);
