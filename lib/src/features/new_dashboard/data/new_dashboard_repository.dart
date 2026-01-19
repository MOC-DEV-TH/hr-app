import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/new_dashboard/model/attended_overiew_response.dart';
import 'package:hr_app/src/features/new_dashboard/model/total_employee_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../home/model/attendance_response.dart';

part 'new_dashboard_repository.g.dart';

class NewDashboardRepository {
  NewDashboardRepository({required this.dio,required this.ref});

  final Dio dio;
  final Ref ref;
  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));


  ///get attended overview data
  Future<AttendanceOverviewResponse> fetchAttendanceOverviewData({
    String? date,
  }) async {
    try {
      final query = <String, String>{};

      if (date != null && date.trim().isNotEmpty) {
        query['date'] = date.trim();
      }
      final res = await dio.get(
        kEndPointGetDashboardAttendedOverview,
        queryParameters: query.isEmpty ? null : query,
      );
      return AttendanceOverviewResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///get all total employee
  Future<TotalEmployeeResponse> fetchTotalEmployeeData() async {
    try {
      final response = await _dioV2
          .get(kEndPointTotalEmployee);
      TotalEmployeeResponse data = TotalEmployeeResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
NewDashboardRepository newDashboardRepository(NewDashboardRepositoryRef ref) {
  return NewDashboardRepository(dio: ref.watch(dioProvider()),ref: ref);
}

@riverpod
Future<AttendanceOverviewResponse> fetchDashboardAttendedOverview(
  FetchDashboardAttendedOverviewRef ref,{String? date}
) async {
  final provider = ref.watch(newDashboardRepositoryProvider);
  return provider.fetchAttendanceOverviewData(date: date);
}

@riverpod
Future<TotalEmployeeResponse> fetchTotalEmployeeData(
    FetchTotalEmployeeDataRef ref,{String? date}
    ) async {
  final provider = ref.watch(newDashboardRepositoryProvider);
  return provider.fetchTotalEmployeeData();
}
