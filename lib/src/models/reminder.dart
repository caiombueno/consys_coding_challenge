import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef ReminderId = int;

class Reminder extends Equatable {
  const Reminder({
    required this.id,
    required this.taskId,
    this.title,
    this.body,
    required this.scheduledDate,
  });
  final ReminderId id;
  final TaskId taskId;
  final String? title;
  final String? body;
  final DateTime scheduledDate;

  factory Reminder.fromTask(
      {required Task task, required DateTime scheduledDate}) {
    final taskId = task.id;
    return Reminder(
      id: taskId.hashCode,
      taskId: task.id,
      title: task.title,
      body: task.description,
      scheduledDate: scheduledDate,
    );
  }

  factory Reminder.fromActiveNotification({
    required ActiveNotification notification,
    required TaskId taskId,
    required DateTime scheduledDate,
  }) {
    try {
      final id = notification.id;
      if (id == null) {
        throw const ReminderCreateException();
      }
      return Reminder(
        id: id,
        taskId: taskId,
        title: notification.title,
        body: notification.body,
        scheduledDate: scheduledDate,
      );
    } catch (e) {
      throw const ReminderCreateException();
    }
  }

  @override
  List<Object?> get props => [id, taskId, title, body, scheduledDate];
}
