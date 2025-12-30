import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/secure_storage.dart';
import 'api_constants.dart';
import 'deadline_retry_interceptor.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref, {String? baseUrl}) {
  final token = GetStorage().read(SecureDataList.authToken.name) as String?;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? kBaseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra.putIfAbsent(
          'deadline',
              () => DateTime.now().add(const Duration(minutes: 1)),
        );
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(DeadlineRetryInterceptor(dio));

  return dio;
}
