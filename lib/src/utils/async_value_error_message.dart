import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueErrorMessage on AsyncValue {
  String get errorMessage {
    final error = this.error;
    return switch (error) {
          AppException e => e.message,
          Exception e => e.toString(),
          _ => 'An error occurred',
        } ??
        'An unknown error occurred';
  }
}
