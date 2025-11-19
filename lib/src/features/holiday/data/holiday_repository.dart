import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/holiday/model/holiday_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../home/model/attendance_response.dart';

part 'holiday_repository.g.dart';

class HolidayRepository {
  HolidayRepository({required this.dio});

  final Dio dio;


  ///get all holiday data
  Future<HolidayResponse> fetchHolidayData({int? businessUnitId}) async {
    try {
      final response = await dio.get(
        kEndPointHolidayList,
        queryParameters: businessUnitId != null
            ? {'business_unit': businessUnitId}
            : null,
      );

      final data = HolidayResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }
}

@riverpod
HolidayRepository holidayRepository(HolidayRepositoryRef ref) {
  return HolidayRepository(dio: ref.watch(dioProvider));
}

@riverpod
Future<HolidayResponse> fetchHolidays(
    FetchHolidaysRef ref,{int? businessUnitId}
    ) async {
  final provider = ref.watch(holidayRepositoryProvider);
  return provider.fetchHolidayData(businessUnitId: businessUnitId);
}


