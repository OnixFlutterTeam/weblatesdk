import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weblate_sdk/src/storage/local_translation_storage.dart';

abstract class PersistedRequest<I, T> {
  @protected
  final Dio dio;
  @protected
  final LocalTranslationStorage storage;
  @protected
  final String projectName;
  @protected
  final String componentName;

  @protected
  abstract final String apiEndpoint;

  PersistedRequest({
    required this.dio,
    required this.storage,
    required this.projectName,
    required this.componentName,
  });

  Future<T> call(I param);

  @protected
  Future<T> getRemote({
    String? param,
  });

  @protected
  Future<void> persist(
    T data, {
    String? param,
  });

  @protected
  String parseDioErrorMessage(DioException dioError) {
    if (dioError.response?.data != null) {
      return '${dioError.response?.statusCode}: ${dioError.response?.data['detail']}';
    } else {
      return '${dioError.type}: ${dioError.message}';
    }
  }
}
