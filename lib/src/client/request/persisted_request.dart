import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:weblate_sdk/src/storage/hive_storage.dart';

abstract class PersistedRequest<I, T> {
  @protected
  final Dio dio;
  @protected
  final HiveStorage storage;
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
