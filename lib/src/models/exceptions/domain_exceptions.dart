import 'package:equatable/equatable.dart';

sealed class DomainException extends Equatable implements Exception {
  final String code;
  final String? message;

  const DomainException({required this.code, this.message});

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
