import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/features/home/model/config_response.dart';
import 'package:hr_app/src/features/home/model/employee_dashboard_response.dart';
import 'package:hr_app/src/features/home/model/user_address_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../../utils/secure_storage.dart';
import '../model/attendance_status_response.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));

  SecureStorage get _secureStorage => ref.read(secureStorageProvider);

  ///compute period working hour
  ({String clockInText, String clockOutText, String periodText})
  computeWorkingPeriod(List<Attendance> attendances, {DateTime? now}) {
    final first = attendances.firstOrNull;
    final checkInDt = (first?.checkIn)?.asDateTimeFlex();
    final checkOutDt = (first?.checkOut)?.asDateTimeFlex();

    final end = checkOutDt ?? (now ?? DateTime.now());
    final dur = (checkInDt == null) ? Duration.zero : end.difference(checkInDt);

    final clockInText =
        (checkInDt != null) ? DateFormat('hh:mm a').format(checkInDt) : '--:--';
    final clockOutText =
        (checkOutDt != null)
            ? DateFormat('hh:mm a').format(checkOutDt)
            : DateFormat('hh:mm a').format(end);
    final periodText = dur.toHrsLabel();

    return (
      clockInText: clockInText,
      clockOutText: clockOutText,
      periodText: periodText,
    );
  }

  ///get config data
  Future<ConfigResponse> fetchConfig() async {
    try {
      final response = await dio.get(kEndPointGetConfig);
      ConfigResponse data = ConfigResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  /// check in
  Future<String> checkIn({
    required String type,
    int? addressId,
    String? currentTimezone,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'type': type,
        if (addressId != null) 'address_id': addressId,
        if (currentTimezone != null) 'time_zone': currentTimezone,
      };

      final response = await _dioV2.post(kEndPointCheckIn, data: requestData);

      final rawResponse = response.data;

      if (rawResponse is! Map) {
        throw Exception('Invalid check-in response');
      }

      final responseData = Map<String, dynamic>.from(rawResponse);

      final statusCode = int.tryParse(
        responseData['status_code']?.toString() ?? '',
      );

      if (statusCode != 200) {
        throw Exception(
          responseData['message']?.toString() ?? 'Check-in failed',
        );
      }

      final rawCheckInData = responseData['data'];

      if (rawCheckInData is! Map) {
        throw Exception('Check-in data was not returned');
      }

      final checkInData = Map<String, dynamic>.from(rawCheckInData);

      final checkInValue = checkInData['check_in']?.toString().trim();

      if (checkInValue == null || checkInValue.isEmpty) {
        throw Exception('Check-in date was not returned');
      }

      /// 2026-07-24 10:41:37 → 2026-07-24
      final checkInDate = checkInValue.split(RegExp(r'\s+')).first;

      //await _secureStorage.saveCheckInDate(checkInDate);

      debugPrint('Saved check-in date: $checkInDate');

      return checkInDate;
    } on DioException catch (error) {
      final errorData = error.response?.data;

      if (errorData is Map) {
        final message = errorData['message']?.toString();

        if (message != null && message.trim().isNotEmpty) {
          throw Exception(message);
        }
      }

      throw Exception(ErrorHandler.handle(error).failure.message);
    }
  }

  Future<bool> checkOut({String? reason}) async {
    try {
      final response = await _dioV2.post(
        kEndPointCheckOut,
        data: {
          if (reason != null && reason.trim().isNotEmpty)
            'log_out_reason': reason.trim(),
        },
      );

      debugPrint('Checkout response: ${response.data}');

      final httpSuccess =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      if (!httpSuccess) {
        throw Exception('Checkout failed (${response.statusCode}).');
      }

      final rawData = response.data;

      if (rawData is! Map) {
        throw Exception('Invalid checkout response.');
      }

      final data = Map<String, dynamic>.from(rawData);

      final statusCode = int.tryParse(data['status_code']?.toString() ?? '');

      final responseCode = data['response_code']?.toString().trim();

      final status = data['status']?.toString().trim().toLowerCase();

      final message = data['message']?.toString().trim();

      final normalizedMessage = message?.toLowerCase();

      final resultData = data['data'];

      String? checkoutTime;

      if (resultData is Map) {
        checkoutTime = resultData['check_out']?.toString().trim();
      }

      final hasCheckoutTime =
          checkoutTime != null &&
          checkoutTime.isNotEmpty &&
          checkoutTime.toLowerCase() != 'null';

      final isSuccess =
          statusCode == 200 ||
          responseCode == '000' ||
          status == 'success' ||
          status == 'true' ||
          normalizedMessage == 'success';

      if (!isSuccess) {
        throw Exception(
          message?.isNotEmpty == true ? message! : 'Checkout failed.',
        );
      }

      if (!hasCheckoutTime) {
        throw Exception(
          'Checkout completed, but checkout time was not returned.',
        );
      }

      debugPrint('Checkout successful at: $checkoutTime');

      return true;
    } on DioException catch (error) {
      final errorData = error.response?.data;

      String message = error.message ?? 'Network error';

      if (errorData is Map) {
        final serverMessage = errorData['message']?.toString().trim();

        if (serverMessage != null && serverMessage.isNotEmpty) {
          message = serverMessage;
        }
      }

      throw Exception(message);
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception(error.toString());
    }
  }

  ///get all attendance data
  Future<AttendanceResponse> fetchAttendanceData() async {
    try {
      final response = await dio.get(kEndPointAttendanceList);
      AttendanceResponse data = AttendanceResponse.fromJson(response.data);

      debugPrint("Attendance Response Data::${response.data}");

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch user address list and save to storage
  Future<UserAddressResponse> fetchEmployeeAddresses() async {
    try {
      final response = await dio.get(kEndPointUserAddress);

      final data = UserAddressResponse.fromJson(response.data);
      ref.read(secureStorageProvider).saveEmployeeAddresses(data.data ?? []);

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  /// Fetch latest attendance status
  Future<AttendanceStatusResponse> fetchLatestAttendanceStatus() async {
    try {
      final response = await _dioV2.get(
        kEndPointLatestAttendanceStatus,
      );

      debugPrint('Latest Attendance status response: ${response.data}');

      final rawData = response.data;

      if (rawData is! Map) {
        throw Exception('Invalid attendance status response.');
      }

      return AttendanceStatusResponse.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    } on DioException catch (error) {
      final errorData = error.response?.data;

      String message = ErrorHandler.handle(error).failure.message;

      if (errorData is Map) {
        final serverMessage = errorData['message']?.toString().trim();

        if (serverMessage != null && serverMessage.isNotEmpty) {
          message = serverMessage;
        }
      }

      throw Exception(message);
    }
  }

  /// Update yesterday checkout
  Future<bool> updateYesterdayCheckout({
    required int userId,
    required String time,
    required String date
  }) async {
    try {
      final requestData = <String, dynamic>{
        'user_id': userId,
        'date': date,
        'time': time,
      };

      debugPrint('Yesterday checkout request: $requestData');

      final response = await _dioV2.post(
        kEndPointUpdateYesterdayCheckout,
        data: requestData,
      );

      final rawResponse = response.data;

      if (rawResponse is! Map) {
        throw Exception('Invalid yesterday checkout response.');
      }

      final responseData = Map<String, dynamic>.from(rawResponse);

      final statusCode = int.tryParse(
        responseData['status_code']?.toString() ?? '',
      );

      final message = responseData['message']?.toString().trim();

      if (statusCode != 200) {
        throw Exception(
          message?.isNotEmpty == true
              ? message!
              : 'Unable to update yesterday checkout.',
        );
      }

      return true;
    } on DioException catch (error) {
      final errorData = error.response?.data;

      String message = ErrorHandler.handle(error).failure.message;

      if (errorData is Map) {
        final serverMessage = errorData['message']?.toString().trim();

        if (serverMessage != null && serverMessage.isNotEmpty) {
          message = serverMessage;
        }
      }

      throw Exception(message);
    }
  }

  /// Fetch employee dashboard
  Future<EmployeeDashboardResponse> fetchEmployeeDashboard({
    required int year,
    required int month,
  }) async {
    try {
      final response = await dio.get(
        kEndPointGetEmployeeDashboard,
        queryParameters: {
          'year': year,
          'month': month,
        },
      );

      final rawData = response.data;

      if (rawData is! Map) {
        throw Exception('Invalid response.');
      }

      return EmployeeDashboardResponse.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    } on DioException catch (error) {
      final errorData = error.response?.data;

      String message =
          ErrorHandler.handle(error).failure.message;

      if (errorData is Map) {
        final serverMessage =
        errorData['message']?.toString().trim();

        if (serverMessage != null &&
            serverMessage.isNotEmpty) {
          message = serverMessage;
        }
      }

      throw Exception(message);
    }
  }

}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<AttendanceResponse> fetchAttendanceData(
  FetchAttendanceDataRef ref,
) async {
  final provider = ref.watch(homeRepositoryProvider);
  return provider.fetchAttendanceData();
}

@riverpod
Future<ConfigResponse> fetchConfigData(FetchConfigDataRef ref) async {
  final provider = ref.watch(homeRepositoryProvider);
  return provider.fetchConfig();
}

@riverpod
Future<EmployeeDashboardResponse> fetchEmployeeDashboard(
    FetchEmployeeDashboardRef ref, {
      required int year,
      required int month,
    }) async {
  final repository = ref.watch(
    homeRepositoryProvider,
  );

  return repository.fetchEmployeeDashboard(
    year: year,
    month: month,
  );
}
