import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String code;
  final String? message;

  const AppException({required this.code, this.message});

  @override
  List<Object?> get props => [code, message];
}

class EntityInitializationException extends AppException {
  const EntityInitializationException()
      : super(code: 'ENTITY-INITIALIZATION-FAILED');
}
