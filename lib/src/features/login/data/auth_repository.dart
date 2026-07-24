import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_app/src/features/login/model/login_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../exceptions/app_exception.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_no_token.dart';
import '../../../network/error_handler.dart';
import '../../../utils/secure_storage.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  ///login
  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (password.isEmpty) {
      throw EmptyPhoneNumberOrPasswordException();
    }

    try {
      final baseOptions = BaseOptions(
        baseUrl: kBaseUrl,

        // Time allowed to connect to the server
        connectTimeout: const Duration(seconds: 30),

        // Time allowed to receive the server response
        receiveTimeout: const Duration(seconds: 30),

        // Time allowed to send request data
        sendTimeout: const Duration(seconds: 30),

        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final dio = Dio(baseOptions);

      final response = await dio.post(
        kEndPointLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data;

      if (responseData is! Map ||
          responseData['data'] is! Map) {
        throw Exception(
          'Invalid login response.',
        );
      }

      final data = Map<String, dynamic>.from(
        responseData['data'] as Map,
      );

      final accessToken =
      data['access_token']?.toString();

      final role = data['role']?.toString();

      final rawUser = data['user'];

      if (accessToken == null ||
          accessToken.isEmpty ||
          rawUser is! Map) {
        throw Exception(
          'Login information was not returned.',
        );
      }

      final userData = Map<String, dynamic>.from(
        rawUser,
      );

      final tokenBox = GetStorage();

      await tokenBox.write(
        SecureDataList.authToken.name,
        accessToken,
      );

      if (role != null && role.isNotEmpty) {
        await ref
            .read(secureStorageProvider)
            .saveLoginUserRole(role);
      }

      await tokenBox.write(
        SecureDataList.isRemoteLogin.name,
        userData['allow_remote_login']
            ?.toString(),
      );

      await ref
          .read(secureStorageProvider)
          .saveUser(
        UserVO.fromJson(userData),
      );
    } on DioException catch (error) {
      final errorData = error.response?.data;

      if (errorData is Map) {
        final serverMessage =
        errorData['message']?.toString().trim();

        if (serverMessage != null &&
            serverMessage.isNotEmpty) {
          throw serverMessage;
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw 'Connection timed out after 30 seconds.';

        case DioExceptionType.receiveTimeout:
          throw 'The server did not respond within 30 seconds.';

        case DioExceptionType.sendTimeout:
          throw 'The request could not be sent within 30 seconds.';

        default:
          throw ErrorHandler.handle(error)
              .failure
              .message;
      }
    } catch (error) {
      throw error.toString();
    }
  }
}

@riverpod
AuthRepository authRepositoryNoToken(AuthRepositoryNoTokenRef ref) {
  return AuthRepository(dio: ref.watch(dioNoTokenProvider), ref: ref);
}
