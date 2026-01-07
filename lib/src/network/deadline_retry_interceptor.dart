import 'dart:async';
import 'package:dio/dio.dart';

class DeadlineRetryInterceptor extends Interceptor {
  DeadlineRetryInterceptor(this.dio);

  final Dio dio;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    // Convert logical API error (status_code != 200) -> DioException
    if (data is Map && data['status_code'] != null) {
      final sc = data['status_code'];
      final int? statusCode =
      sc is int ? sc : (sc is String ? int.tryParse(sc) : null);

      if (statusCode != null && statusCode != 200) {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: data['message'] ?? 'API error',
          ),
        );
      }
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    // ⛔ If server replied with 4xx/5xx -> do NOT retry, fail immediately
    // (500 error will come here)
    if (err.type == DioExceptionType.badResponse) {
      return handler.reject(err);
    }

    // ✅ Safe deadline read
    final deadlineRaw = options.extra['deadline'];
    final DateTime deadline = deadlineRaw is DateTime
        ? deadlineRaw
        : DateTime.now().add(const Duration(minutes: 1));

    // ✅ Retry ONLY network problems (no internet / timeouts)
    final isRetryable =
        err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError;

    if (!isRetryable || DateTime.now().isAfter(deadline)) {
      return handler.reject(err);
    }

    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      return handler.reject(
        e is DioException
            ? e
            : DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
