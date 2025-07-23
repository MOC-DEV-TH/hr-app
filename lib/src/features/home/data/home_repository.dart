import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository({required this.dio});

  final Dio dio;

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
  Future<void> checkOut() async {
    debugPrint("CheckOut");
    try {
      final response = await dio.post(kEndPointCheckOut);
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
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(dio: ref.watch(dioProvider));
}

@riverpod
Future<AttendanceResponse> fetchAttendanceData(FetchAttendanceDataRef ref,) async {
  final provider = ref.watch(homeRepositoryProvider);
  return provider.fetchAttendanceData();
}
