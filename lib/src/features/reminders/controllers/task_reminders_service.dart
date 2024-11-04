import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notifications_service.dart';

class TaskRemindersService {
  final NotificationService _notificationsService;

  TaskRemindersService(this._notificationsService);

  Future<void> createReminder({
    required TaskId taskId,
    String? title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    try {
      final reminderId = taskId.hashCode;

      await _notificationsService.scheduleNotification(
        id: reminderId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: taskId,
      );
    } catch (e) {
      throw const ReminderCreateException();
    }
  }

  Future<void> removeReminder(TaskId taskId) async {
    final reminderId = taskId.hashCode;
    try {
      await _notificationsService.cancelNotification(reminderId);
    } catch (e) {
      throw const ReminderRemoveException();
    }
  }
}

final taskReminderServiceProvider = Provider<TaskRemindersService>((ref) {
  final notificationsService = ref.read(notificationsServiceProvider);
  return TaskRemindersService(notificationsService);
});
