import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employee_list/model/employee_list_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';

part 'employee_list_repository.g.dart';

class EmployeeListRepository {
  EmployeeListRepository({required this.dio,required this.ref});

  final Dio dio;
  final Ref ref;


  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));



  ///get employees
  Future<EmployeeListResponse> fetchEmployees({required int pageNo}) async {
    try {
      final response = await _dioV2
          .get("$kEndPointGetEmployeeList?page=$pageNo");
      EmployeeListResponse data = EmployeeListResponse.fromJson(response.data);

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///search employees
  Future<EmployeeListResponse> searchEmployees({required String query}) async {
    try {
      final response = await _dioV2
          .get("$kEndPointGetEmployeeList?search=$query");
      EmployeeListResponse data = EmployeeListResponse.fromJson(response.data);

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
EmployeeListRepository employeeListRepository(EmployeeListRepositoryRef ref) {
  return EmployeeListRepository(dio: ref.watch(dioProvider()),ref:  ref);
}

@riverpod
Future<EmployeeListResponse> fetchEmployeeListData(FetchEmployeeListDataRef ref,{required int pageNo}) async {
  final provider = ref.watch(employeeListRepositoryProvider);
  return provider.fetchEmployees(pageNo:pageNo);
}

@riverpod
Future<EmployeeListResponse> searchEmployeeListData(SearchEmployeeListDataRef ref,{required String query}) async {
  final provider = ref.watch(employeeListRepositoryProvider);
  return provider.searchEmployees(query:query);
}
