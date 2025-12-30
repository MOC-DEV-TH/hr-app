import 'dart:async';
import 'package:dio/dio.dart';

class DeadlineRetryInterceptor extends Interceptor {
  DeadlineRetryInterceptor(this.dio);

  final Dio dio;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    /// Convert logical API error → DioException
    if (data is Map && data['status_code'] != null && data['status_code'] != 200) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          type: DioExceptionType.badResponse,
          error: data['message'] ?? 'API error',
          response: response,
        ),
      );
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    /// ✅ Safe deadline read (avoid cast crash)
    final deadlineRaw = options.extra['deadline'];
    final DateTime deadline = deadlineRaw is DateTime
        ? deadlineRaw
        : DateTime.now().add(const Duration(minutes: 1));

    final isRetryable =
        err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.badResponse;

    if (DateTime.now().isAfter(deadline) || !isRetryable) {
      return handler.reject(err);
    }

    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      // ✅ Never cast blindly
      if (e is DioException) {
        return handler.reject(e);
      }
      return handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
