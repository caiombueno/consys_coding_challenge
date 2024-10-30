import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLocalStorageDataSource extends Mock
    implements LocalStorageDataSource {}
