import 'package:consys_coding_challenge/src/models/models.dart';

sealed class DomainException extends AppException {
  const DomainException({required super.code, super.message});

  @override
  List<Object?> get props => [code, message];
}

class TaskSearchException extends DomainException {
  const TaskSearchException()
      : super(code: 'TASK_SEARCH_FAILED', message: 'Failed to find tasks.');
}

class TaskDeleteException extends DomainException {
  const TaskDeleteException()
      : super(code: 'TASK_DELETE_FAILED', message: 'Failed to delete task.');
}

class TaskAlreadyExistsException extends DomainException {
  const TaskAlreadyExistsException()
      : super(
            code: 'TASK_ALREADY_EXISTS',
            message: 'Task with the same ID already exists.');
}

class TaskCreateException extends DomainException {
  const TaskCreateException()
      : super(code: 'TASK_CREATE_FAILED', message: 'Failed to create task.');
}

class TaskNotFoundException extends DomainException {
  const TaskNotFoundException()
      : super(code: 'TASK_NOT_FOUND_FAILED', message: 'Failed to find task.');
}

class TaskEditException extends DomainException {
  const TaskEditException()
      : super(code: 'TASK_EDIT_FAILED', message: 'Failed to edit task.');
}
