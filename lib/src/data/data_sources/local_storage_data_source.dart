import 'dart:convert';
import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDataSource {
  late final SharedPreferences _prefs;

  Future<void> init(
      {@visibleForTesting SharedPreferences? sharedPreferences}) async {
    try {
      _prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    } catch (e) {
      throw const InitializationException();
    }
  }

  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      final success = await _prefs.setString(key, jsonString);
      if (!success) throw Exception();
    } catch (e) {
      throw const DataException(code: 'LOCAL_STORAGE_SAVE_FAILED');
    }
  }

  Map<String, dynamic> getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) throw Exception();
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw const DataException(code: 'LOCAL_STORAGE_READ_FAILED');
    }
  }

  Future<void> remove(String key) async {
    try {
      final success = await _prefs.remove(key);
      if (!success) throw Exception();
    } catch (e) {
      throw const DataException(code: 'LOCAL_STORAGE_REMOVE_FAILED');
    }
  }
}

final localStorageDataSourceProvider =
    FutureProvider.autoDispose<LocalStorageDataSource>((ref) async {
  final dataSource = LocalStorageDataSource();
  await dataSource.init();
  return dataSource;
});
