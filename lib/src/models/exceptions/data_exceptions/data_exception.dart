import 'package:equatable/equatable.dart';

class DataException extends Equatable implements Exception {
  final String code;
  final String? message;

  const DataException({required this.code, this.message});

  @override
  List<Object?> get props => [code, message];
}

class InitializationException extends DataException {
  const InitializationException() : super(code: 'INITIALIZATION_FAILED');
}
