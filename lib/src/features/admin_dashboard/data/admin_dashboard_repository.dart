import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/admin_dashboard/model/admin_dasbhoard_response.dart';
import 'package:hr_app/src/features/admin_dashboard/model/business_unit_response.dart';
import 'package:hr_app/src/features/admin_dashboard/model/employee_dropdown_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../../utils/secure_storage.dart';

part 'admin_dashboard_repository.g.dart';

class AdminDashboardRepository {
  AdminDashboardRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));

  ///fetch admin dashboard data
  Future<AdminDashboardResponse> fetchAdminDashboardData({
    required int businessUnitId,
    required String date,
  }) async {
    try {
      final response = await dio.get(
        kEndPointGetAdminDashboard,
        data: {
          "bussiness_unit_id": businessUnitId,
          "date": date,
        },
      );
      return AdminDashboardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch business units data
  Future<BusinessUnitResponse> fetchBusinessUnitData() async {
    try {
      final response = await _dioV2.get(kEndPointGetBusinessUnits);
      BusinessUnitResponse data = BusinessUnitResponse.fromJson(response.data);

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch employee dropdown data and save to storage
  Future<EmployeeDropdownResponse> fetchEmployeeDropdownData() async {
    try {
      final response = await dio.get(kEndPointGetEmployeeDropdownData);
      EmployeeDropdownResponse data = EmployeeDropdownResponse.fromJson(
        response.data,
      );
      await ref
          .read(secureStorageProvider)
          .saveEmployeeDropdown(data.data ?? EmployeeDropdownVO());
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch all business unit list and save to storage
  Future<BusinessUnitResponse> fetchAllBusinessUnitList() async {
    try {
      final response = await dio.get(kEndPointAllBusinessUnitList);
      BusinessUnitResponse data = BusinessUnitResponse.fromJson(
        response.data,
      );
      await ref
          .read(secureStorageProvider)
          .saveBusinessUnits(data.data ?? []);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
AdminDashboardRepository adminDashboardRepository(
  AdminDashboardRepositoryRef ref,
) {
  return AdminDashboardRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<BusinessUnitResponse> fetchBusinessUnits(
  FetchBusinessUnitsRef ref,
) async {
  final provider = ref.watch(adminDashboardRepositoryProvider);
  return provider.fetchBusinessUnitData();
}

@riverpod
Future<AdminDashboardResponse> fetchAdminDashboardData(
  FetchAdminDashboardDataRef ref, {
  required int businessUnitId,
  required String date,
}) async {
  final provider = ref.watch(adminDashboardRepositoryProvider);
  return provider.fetchAdminDashboardData(
    businessUnitId: businessUnitId,
    date: date,
  );
}
