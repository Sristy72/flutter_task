import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constant.dart';
import 'api_exception.dart';
import 'constants/api_constant.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(
        milliseconds: AppConstants.receiveTimeout,
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🌐 [API Request] ${options.method} ${options.uri}');
          debugPrint('📦 [Request Data] ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [API Response] ${response.statusCode} ${response.requestOptions.uri}');
          debugPrint('📦 [Response Data] ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ [API Error] ${error.response?.statusCode} ${error.requestOptions.uri}');
          debugPrint('⚠️ [Error Message] ${error.message}');
          debugPrint('📦 [Error Data] ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> put(
      String path, {
        dynamic data,
      }) async {
    try {
      return await dio.put(
        path,
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> delete(
      String path, {
        dynamic data,
      }) async {
    try {
      return await dio.delete(
        path,
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  ApiException _handleDioException(DioException error) {
    String message = 'Something went wrong';

    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map) {
        if (data.containsKey('detail')) {
          message = data['detail']?.toString() ?? 'Server error';
        } else if (data.containsKey('message')) {
          message = data['message']?.toString() ?? 'Server error';
        } else if (data['data'] is Map && (data['data'] as Map).containsKey('detail')) {
          message = (data['data'] as Map)['detail']?.toString() ?? 'Server error';
        } else if (data.containsKey('error')) {
          message = data['error']?.toString() ?? 'Server error';
        } else if (data.isNotEmpty) {
          final firstVal = data.values.first;
          if (firstVal is List && firstVal.isNotEmpty) {
            message = firstVal.first.toString();
          } else if (firstVal is String) {
            message = firstVal;
          } else {
            message = 'Server error (${error.response?.statusCode})';
          }
        }
      } else if (data is String && data.isNotEmpty) {
        message = data;
      } else {
        message = 'Server error (${error.response?.statusCode})';
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Request timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }
}