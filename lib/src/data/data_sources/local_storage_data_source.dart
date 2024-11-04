import 'dart:convert';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDataSource {
  final SharedPreferencesAsync _prefs;

  const LocalStorageDataSource(this._prefs);

  Future<void> saveJsonList(String key, List<Map<String, dynamic>> json) async {
    try {
      final jsonStringList = json.toStringList();
      await _prefs.setStringList(key, jsonStringList);
    } catch (e) {
      throw const DataSaveException();
    }
  }

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    try {
      final jsonStringList = await _prefs.getStringList(key);

      if (jsonStringList == null) throw const DataAccessException();

      return jsonStringList.toJsonList();
    } catch (e) {
      throw const DataAccessException();
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw const DataDeleteException();
    }
  }
}

final localStorageDataSourceProvider =
    Provider.autoDispose<LocalStorageDataSource>((ref) {
  final sharedPreferences = SharedPreferencesAsync();

  return LocalStorageDataSource(sharedPreferences);
});

extension on List<Map<String, dynamic>> {
  List<String> toStringList() => map((e) => json.encode(e)).toList();
}

extension on List<String> {
  List<Map<String, dynamic>> toJsonList() =>
      map((e) => json.decode(e) as Map<String, dynamic>).toList();
}
