import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';

class DioClient {
  static late Dio _instance;
  static const _storage = FlutterSecureStorage();
  
  static void initialize({required String baseUrl}) {
    _instance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Version': AppConstants.appVersion,
          'X-Platform': 'mobile',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  static Dio get instance => _instance;
  
  static void _setupInterceptors() {
    // Auth interceptor
    _instance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: AppConstants.keyUserToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry original request
              final token = await _storage.read(key: AppConstants.keyUserToken);
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              return handler.resolve(await _instance.fetch(error.requestOptions));
            } else {
              // Clear tokens and redirect to login
              await _clearAuthData();
              // Navigation will be handled by auth state listener
            }
          }
          handler.next(error);
        },
      ),
    );
    
    // Logging interceptor (only in debug)
    _instance.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
  
  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.keyRefreshToken);
      if (refreshToken == null) return false;
      
      final response = await Dio().post(
        '${_instance.options.baseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _storage.write(key: AppConstants.keyUserToken, value: response.data['accessToken']);
        await _storage.write(key: AppConstants.keyRefreshToken, value: response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
  
  static Future<void> _clearAuthData() async {
    await _storage.delete(key: AppConstants.keyUserToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserProfile);
  }
  
  static Future<void> setAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: AppConstants.keyUserToken, value: accessToken);
    await _storage.write(key: AppConstants.keyRefreshToken, value: refreshToken);
  }
  
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.keyUserToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.keyRefreshToken);
  }
  
  static Future<void> clearAuth() async {
    await _clearAuthData();
  }
  
  // Helper methods for common HTTP verbs
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance.get<T>(path, queryParameters: queryParameters, options: options);
  }
  
  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
  
  static Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
  
  static Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
  
  static Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}

// Error handling extension
extension DioErrorHandler on DioException {
  AppException toAppException() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final data = response?.data;
        final message = data is Map ? (data['message'] as String?) : null;
        final code = data is Map ? (data['code'] as String?) : null;
        
        switch (statusCode) {
          case 400:
            return ValidationException(
              message: message ?? 'Invalid request',
              details: data is Map ? Map<String, dynamic>.from(data) : null,
            );
          case 401:
            return AuthenticationException(message: message ?? 'Authentication required');
          case 403:
            return AuthorizationException(message: message ?? 'Access denied');
          case 404:
            return NotFoundException(resource: 'Resource');
          case 409:
            return ConflictException(message: message ?? 'Conflict');
          case 429:
            return RateLimitException(message: message ?? 'Too many requests');
          case 500:
          case 502:
          case 503:
            return ServerException(message: message ?? 'Server error. Please try again later.');
          default:
            return UnknownException(
              message: message ?? 'An error occurred',
              code: code ?? 'UNKNOWN_ERROR',
              statusCode: statusCode,
            );
        }
      case DioExceptionType.cancel:
        return const UnknownException(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.unknown:
      default:
        return const NetworkException();
    }
  }
}