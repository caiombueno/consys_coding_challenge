import 'package:consys_coding_challenge/src/data/data_sources/local_storage_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:consys_coding_challenge/src/models/models.dart';

import '../../../mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalStorageDataSource localStorageDataSource;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    mockSharedPreferences = MockSharedPreferences();
    localStorageDataSource = LocalStorageDataSource();
    await localStorageDataSource.init(sharedPreferences: mockSharedPreferences);
  });

  group('LocalStorageDataSource', () {
    const testKey = 'test_key';
    final testJson = {'key': 'value'};
    const jsonString = '{"key":"value"}';

    test('saveJson should save JSON to SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(testKey, jsonString))
          .thenAnswer((_) async => true);

      // Act
      await localStorageDataSource.saveJson(testKey, testJson);

      // Assert
      verify(() => mockSharedPreferences.setString(testKey, jsonString))
          .called(1);
    });

    test('saveJson should throw DataException if saving fails', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(testKey, jsonString))
          .thenAnswer((_) async => false);

      // Act & Assert
      expect(() => localStorageDataSource.saveJson(testKey, testJson),
          throwsA(isA<DataException>()));
    });

    test('getJson should return JSON from SharedPreferences', () {
      // Arrange
      when(() => mockSharedPreferences.getString(testKey))
          .thenReturn(jsonString);

      // Act
      final result = localStorageDataSource.getJson(testKey);

      // Assert
      expect(result, testJson);
    });

    test('getJson should throw DataException if JSON is not found', () {
      // Arrange
      when(() => mockSharedPreferences.getString(testKey)).thenReturn(null);

      // Act & Assert
      expect(() => localStorageDataSource.getJson(testKey),
          throwsA(isA<DataException>()));
    });

    test('remove should remove JSON from SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(testKey))
          .thenAnswer((_) async => true);

      // Act
      await localStorageDataSource.remove(testKey);

      // Assert
      verify(() => mockSharedPreferences.remove(testKey)).called(1);
    });

    test('remove should throw DataException if removal fails', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(testKey))
          .thenAnswer((_) async => false);

      // Act & Assert
      expect(() => localStorageDataSource.remove(testKey),
          throwsA(isA<DataException>()));
    });

    group('localStorageDataSourceProvider', () {
      test(
          'localStorageDataSourceProvider should return LocalStorageDataSource',
          () async {
        // Arrange
        final container = createContainer(
          overrides: [
            sharedPreferencesProvider
                .overrideWith((ref) => mockSharedPreferences),
          ],
        );

        // Act
        final localStorageDataSource =
            await container.read(localStorageDataSourceProvider.future);

        // Assert
        expect(localStorageDataSource, isA<LocalStorageDataSource>());
      });

      test(
          'localStorageDataSourceProvider throws EntityInitializationException if SharedPreferences fails',
          () async {
        // Arrange
        final container = createContainer(
          overrides: [
            sharedPreferencesProvider.overrideWith(
                (ref) => throw const EntityInitializationException()),
          ],
        );

        // Act
        final localStorageDataSource =
            container.read(localStorageDataSourceProvider.future);

        // Assert
        expect(localStorageDataSource,
            throwsA(isA<EntityInitializationException>()));
      });
    });
  });
}
