import 'dart:async';

import 'package:consys_coding_challenge/src/features/reminders/controllers/task_reminders_service.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskReminderCreatorController extends AutoDisposeAsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> createReminder(
      {required Task task, required DateTime scheduledDate}) async {
    state = const AsyncLoading();
    try {
      final taskReminderService = ref.read(taskReminderServiceProvider);
      await taskReminderService.createReminder(
        taskId: task.id,
        title: task.title,
        scheduledDate: scheduledDate,
      );
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final taskReminderCreatorControllerProvider =
    AsyncNotifierProvider.autoDispose<TaskReminderCreatorController, bool>(
        () => TaskReminderCreatorController());
