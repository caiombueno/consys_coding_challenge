import 'package:consys_coding_challenge/src/models/models.dart';

sealed class DomainException extends AppException {
  const DomainException({required super.code, super.message});

  @override
  List<Object?> get props => [code, message];
}

class TaskSearchException extends DomainException {
  const TaskSearchException()
      : super(code: 'TASK-SEARCH-FAILED', message: 'Failed to find tasks.');
}

class TaskDeleteException extends DomainException {
  const TaskDeleteException()
      : super(code: 'TASK-DELETE-FAILED', message: 'Failed to delete task.');
}

class TaskAlreadyExistsException extends DomainException {
  const TaskAlreadyExistsException()
      : super(
            code: 'TASK-ALREADY-EXISTS',
            message: 'Task with the same ID already exists.');
}

class TaskCreateException extends DomainException {
  const TaskCreateException()
      : super(code: 'TASK-CREATE-FAILED', message: 'Failed to create task.');
}

class TaskNotFoundException extends DomainException {
  const TaskNotFoundException()
      : super(code: 'TASK-NOT-FOUND-FAILED', message: 'Failed to find task.');
}

class TaskEditException extends DomainException {
  const TaskEditException()
      : super(code: 'TASK-EDIT-FAILED', message: 'Failed to edit task.');
}

class ReminderCreateException extends DomainException {
  const ReminderCreateException()
      : super(
            code: 'REMINDER-CREATE-FAILED',
            message: 'Failed to create reminder.');
}

class ReminderRemoveException extends DomainException {
  const ReminderRemoveException()
      : super(
            code: 'REMINDER-REMOVE-FAILED',
            message: 'Failed to remove reminder.');
}

class ReminderNotFoundException extends DomainException {
  const ReminderNotFoundException()
      : super(
            code: 'REMINDER-NOT-FOUND',
            message: 'Failed to retrieve reminder.');
}
