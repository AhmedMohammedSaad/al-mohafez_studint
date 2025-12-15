import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../exception/app_exception.dart';
import 'dio_service.dart';

class AppDio {
  final Dio _dio = DioService.dio;

  // Create (POST)
  Future<Response> post({
    required String path,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await DioService.instance.sendRequest(
        method: 'POST',
        path: path,
        data: data,
        headers: headers ?? await DioService.instance.getHeaders(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> upload({
    required String path,
    required String filePath,
    required String fileField,
    Map<String, dynamic>? additionalData,
    Map<String, String>? headers,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        fileField: await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      };

      if (additionalData != null) {
        formDataMap.addAll(additionalData);
      }

      final FormData formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: headers ?? {}),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Read (GET)
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await DioService.instance.sendRequest(
        method: 'GET',
        path: path,
        queryParams: queryParams,
        headers: headers ?? await DioService.instance.getHeaders(),
      );
      return response;
    } on ServerFailure catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      rethrow;
    }
  }

  // Update (PUT)
  Future<Response> put({
    required String path,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await DioService.instance.sendRequest(
        method: 'PUT',
        path: path,
        data: data,
        headers: headers ?? await DioService.instance.getHeaders(),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Delete (DELETE)
  Future<Response> delete({
    required String path,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await DioService.instance.sendRequest(
        method: 'DELETE',
        path: path,
        data: queryParams,
        headers: await DioService.instance.getHeaders(),
      );
      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint(e.response?.data);
      }
      rethrow;
    }
  }

  // Patch (PATCH)
  Future<Response> patch({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await DioService.instance.sendRequest(
        method: 'PATCH',
        path: path,
        data: data,
        headers: await DioService.instance.getHeaders(),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}
