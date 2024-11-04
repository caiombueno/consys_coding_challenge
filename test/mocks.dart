import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferencesAsync extends Mock
    implements SharedPreferencesAsync {}

class MockLocalStorageDataSource extends Mock
    implements LocalStorageDataSource {}

class MockTaskRepository extends Mock implements TaskRepository {}
