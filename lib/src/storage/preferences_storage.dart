import 'package:flutter/material.dart';

abstract class PreferencesStorage {
  @protected
  final kCacheWriteTimestampKey = 'kCacheWriteTimestampKey';

  Future<int> getCacheTimestamp();

  Future<void> saveCacheTimestamp(int value);
}
