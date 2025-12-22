import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employees_attendances/model/employees_attendances_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';

part 'employees_attendances_repository.g.dart';

class EmployeesAttendancesRepository {
  EmployeesAttendancesRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  ///fetch admin dashboard data
  Future<EmployeesAttendancesResponse> fetchEmployeesAttendancesData({
    required int businessUnitId,
    required String date,
    required int pageNo,
  }) async {
    try {
      final response = await dio.get(
        kEndPointGetEmployeeAttendancesByBU,
        data: {
          "bussiness_unit_id": businessUnitId,
          "date": date,
          "page": pageNo,
        },
      );
      EmployeesAttendancesResponse data = EmployeesAttendancesResponse.fromJson(
        response.data,
      );
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
EmployeesAttendancesRepository employeesAttendancesRepository(
  EmployeesAttendancesRepositoryRef ref,
) {
  return EmployeesAttendancesRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<EmployeesAttendancesResponse> fetchEmployeesAttendances(
  FetchEmployeesAttendancesRef ref, {
  required int businessUnitId,
  required String date,
  required int pageNo,
}) async {
  final provider = ref.watch(employeesAttendancesRepositoryProvider);
  return provider.fetchEmployeesAttendancesData(businessUnitId:businessUnitId,date:date,pageNo:pageNo);
}
