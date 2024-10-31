import 'package:consys_coding_challenge/src/models/models.dart';

// Specific exceptions for common data source error scenarios
class DataException extends AppException {
  const DataException({required super.code, super.message});
}

class DataAccessException extends DataException {
  const DataAccessException()
      : super(
            code: "DATA-ACCESS-FAILED",
            message: "Failed to access local storage.");
}

class DataSaveException extends DataException {
  const DataSaveException()
      : super(
            code: "DATA-SAVE-FAILED",
            message: "Failed to save data in local storage.");
}

class DataDeleteException extends DataException {
  const DataDeleteException()
      : super(
            code: "DATA-DELETE-FAILED",
            message: "Failed to delete data in local storage.");
}
