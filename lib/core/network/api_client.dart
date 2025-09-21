import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sdui_app/core/constants/app_constants.dart';
import 'package:flutter_sdui_app/core/di/injector.dart';
import 'package:flutter_sdui_app/core/errors/exceptions.dart';
import 'package:flutter_sdui_app/core/network/api_endpoints.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';

/// API client for making HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.responseType = ResponseType.json;

    // Add auth interceptor for automatic logout on unauthorized responses
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Auto-logout on unauthorized responses
          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403) {
            _handleUnauthorizedResponse();
          }
          handler.next(error);
        },
      ),
    );

    // Add interceptors for logging, etc.
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  /// Performs a GET request to the specified [endpoint]
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: AppConstants.connectionErrorMessage);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Performs a POST request to the specified [endpoint]
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: AppConstants.connectionErrorMessage);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Performs a PUT request to the specified [endpoint]
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: AppConstants.connectionErrorMessage);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Performs a DELETE request to the specified [endpoint]
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } on SocketException {
      throw NetworkException(message: AppConstants.connectionErrorMessage);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Handles unauthorized responses by automatically logging out the user
  void _handleUnauthorizedResponse() {
    try {
      // Get the authentication cubit and logout the user
      final AuthenticationCubit authCubit = sl<AuthenticationCubit>();
      authCubit.logout();
    } catch (e) {
      // If there's an error getting the cubit, we can't do much
      // The error will still be thrown and handled by the calling code
      if (kDebugMode) {
        print('Error during automatic logout: $e');
      }
    }
  }

  /// Handles Dio errors and throws appropriate exceptions
  Never _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(message: AppConstants.timeoutErrorMessage);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          throw AuthException(message: 'Authentication failed');
        } else if (statusCode == 404) {
          throw ServerException(message: 'Resource not found');
        } else if (statusCode == 422) {
          throw ValidationException(message: 'Validation failed');
        } else {
          throw ServerException(
            message:
                e.response?.data?['message'] ??
                AppConstants.genericErrorMessage,
          );
        }
      case DioExceptionType.cancel:
        throw ServerException(message: 'Request was cancelled');
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          throw NetworkException(message: AppConstants.connectionErrorMessage);
        }
        throw ServerException(
          message: e.message ?? AppConstants.genericErrorMessage,
        );
      default:
        throw ServerException(
          message: e.message ?? AppConstants.genericErrorMessage,
        );
    }
  }
}
