import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/features/home/model/config_response.dart';
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

      // ///save lat , long , allow distance
      // double? userLat = double.tryParse(data.data?.businessUnit?.lat ?? '');
      // double? userLong = double.tryParse(data.data?.businessUnit?.long ?? '');
      // int? allowDistanceRadius = data.data?.allowDistance;
      //
      // // await ref
      // //     .read(secureStorageProvider).saveBusinessUnitConfig(lat: userLat , long: userLong , allowDistance: allowDistanceRadius);
      // debugPrint("Config Response Data::${response.data}");

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///check in
  Future<void> checkIn({required type}) async {
    try {
      final response = await dio.post(kEndPointCheckIn, data: {"type": type});
      debugPrint("CheckIn response::${response.data}");
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }

  ///check out
  Future<void> checkOut({String? reason}) async {
    debugPrint("CheckOut");
    try {
      final response = await dio.post(kEndPointCheckOut,data: {"log_out_reason" : reason});
      debugPrint("CheckOut response::${response.data}");
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
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




}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(dio: ref.watch(dioProvider),ref: ref);
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
