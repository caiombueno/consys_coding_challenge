import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MockSharedPreferencesAsync extends Mock
    implements SharedPreferencesAsync {}

class MockLocalStorageDataSource extends Mock
    implements LocalStorageDataSource {}

class MockLocalTaskDataSource extends Mock implements LocalTaskDataSource {}

class MockTaskRepository extends Mock implements TaskRepository {}

// A generic listener class to track provider notifications
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class MockTaskSummaryListNotifier extends StreamNotifier<List<TaskSummary>>
    with Mock
    implements TaskSummaryListNotifier {}
