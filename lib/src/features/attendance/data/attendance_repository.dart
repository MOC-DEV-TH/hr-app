import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../home/model/attendance_response.dart';

part 'attendance_repository.g.dart';

class AttendanceRepository {
  AttendanceRepository({required this.dio});

  final Dio dio;


  ///get all attendance data
  Future<AttendanceResponse> fetchAttendanceData() async {
    debugPrint("FetchAttensdance");
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
AttendanceRepository attendanceRepository(AttendanceRepositoryRef ref) {
  return AttendanceRepository(dio: ref.watch(dioProvider));
}
