import 'package:consys_coding_challenge/src/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:consys_coding_challenge/src/models/models.dart';

import '../../../mocks.dart';

void main() {
  group('LocalStorageDataSource', () {
    late MockSharedPreferencesAsync mockSharedPreferencesAsync;
    late LocalStorageDataSource localStorageDataSource;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      mockSharedPreferencesAsync = MockSharedPreferencesAsync();
      localStorageDataSource =
          LocalStorageDataSource(mockSharedPreferencesAsync);
    });
    const testKey = 'test_key';
    final testJsonList = [
      {'key': 'value'},
    ];
    final jsonStringList = ['{"key":"value"}'];

    test('saveJsonList should save JSON list to SharedPreferences', () async {
      // Arrange
      when(() =>
              mockSharedPreferencesAsync.setStringList(testKey, jsonStringList))
          .thenAnswer((_) async => true);

      // Act
      await localStorageDataSource.saveJsonList(testKey, testJsonList);

      // Assert
      verify(() =>
              mockSharedPreferencesAsync.setStringList(testKey, jsonStringList))
          .called(1);
    });

    test('saveJsonList should throw DataSaveException if saving fails',
        () async {
      // Arrange
      when(() =>
              mockSharedPreferencesAsync.setStringList(testKey, jsonStringList))
          .thenThrow(const DataSaveException());

      // Act & Assert
      expect(() => localStorageDataSource.saveJsonList(testKey, testJsonList),
          throwsA(isA<DataSaveException>()));
    });

    test('getJsonList should return JSON list from SharedPreferences',
        () async {
      // Arrange
      when(() => mockSharedPreferencesAsync.getStringList(testKey))
          .thenAnswer((_) async => jsonStringList);

      // Act
      final result = await localStorageDataSource.getJsonList(testKey);

      // Assert
      expect(result, testJsonList);
    });

    test(
        'getJsonList should throw DataAccessException if JSON list is not found',
        () async {
      // Arrange
      when(() => mockSharedPreferencesAsync.getStringList(testKey))
          .thenAnswer((_) async => null);

      // Act & Assert
      expect(() => localStorageDataSource.getJsonList(testKey),
          throwsA(isA<DataAccessException>()));
    });

    test('remove should remove JSON list from SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferencesAsync.remove(testKey))
          .thenAnswer((_) async => true);

      // Act
      await localStorageDataSource.remove(testKey);

      // Assert
      verify(() => mockSharedPreferencesAsync.remove(testKey)).called(1);
    });

    test('remove should throw DataDeleteException if removal fails', () async {
      // Arrange
      when(() => mockSharedPreferencesAsync.remove(testKey))
          .thenThrow(const DataDeleteException());

      // Act & Assert
      expect(() => localStorageDataSource.remove(testKey),
          throwsA(isA<DataDeleteException>()));
    });
  });
}
