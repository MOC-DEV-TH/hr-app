import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/features/home/model/config_response.dart';
import 'package:hr_app/src/features/home/model/user_address_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../../utils/secure_storage.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository({required this.dio,required this.ref});

  final Dio dio;
  final Ref ref;

  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));

  ///compute period working hour
  ({String clockInText, String clockOutText, String periodText}) computeWorkingPeriod(
      List<Attendance> attendances, {
        DateTime? now,
      }) {
    final first = attendances.firstOrNull;
    final checkInDt  = (first?.checkIn)?.asDateTimeFlex();
    final checkOutDt = (first?.checkOut)?.asDateTimeFlex();

    final end = checkOutDt ?? (now ?? DateTime.now());
    final dur = (checkInDt == null) ? Duration.zero : end.difference(checkInDt);

    final clockInText  = (checkInDt != null) ? DateFormat('hh:mm a').format(checkInDt) : '--:--';
    final clockOutText = (checkOutDt != null) ? DateFormat('hh:mm a').format(checkOutDt) : DateFormat('hh:mm a').format(end);
    final periodText   = dur.toHrsLabel();

    return (clockInText: clockInText, clockOutText: clockOutText, periodText: periodText);
  }

  ///get config data
  Future<ConfigResponse> fetchConfig() async {
    try {
      final response = await dio
          .get(kEndPointGetConfig);
      ConfigResponse data = ConfigResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  /// check in
  Future<void> checkIn({
    required String type,
    int? addressId,
  }) async {
    try {
      final data = <String, dynamic>{
        "type": type,
        if (addressId != null) "address_id": addressId,
      };

      final response = await _dioV2.post(
        kEndPointCheckIn,
        data: data,
      );

      debugPrint("CheckIn response::${response.data}");
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  Future<bool> checkOut({String? reason}) async {
    try {
      final res = await _dioV2.post(kEndPointCheckOut, data: {
        if (reason != null && reason.trim().isNotEmpty) 'log_out_reason': reason.trim(),
      });

      final ok = res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300;
      if (!ok) {
        final msg = (res.data is Map && res.data['message'] is String)
            ? res.data['message'] as String
            : 'Checkout failed (${res.statusCode}).';
        throw msg;
      }
      debugPrint("Checkout response::${res.data}");
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] is String
          ? e.response?.data['message'] as String
          : (e.message ?? 'Network error');
      throw msg;
    }
  }

  ///get all attendance data
  Future<AttendanceResponse> fetchAttendanceData() async {
    try {
      final response = await dio
          .get(kEndPointAttendanceList);
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


}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(dio: ref.watch(dioProvider()),ref: ref);
}

@riverpod
Future<AttendanceResponse> fetchAttendanceData(FetchAttendanceDataRef ref,) async {
  final provider = ref.watch(homeRepositoryProvider);
  return provider.fetchAttendanceData();
}

@riverpod
Future<ConfigResponse> fetchConfigData(FetchConfigDataRef ref,) async {
  final provider = ref.watch(homeRepositoryProvider);
  return provider.fetchConfig();
}
