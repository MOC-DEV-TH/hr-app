import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';

part 'edit_employee_repository.g.dart';

class EditEmployeeRepository {
  EditEmployeeRepository({required this.dio});

  final Dio dio;

  Future<void> updateEmployee(dynamic payload, String employeeId) async {
    final res = await dio.put(
      "$kEndPointUpdateEmployee/$employeeId",
      data: payload,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: res.data["message"],
      );
    }
  }
}

@riverpod
EditEmployeeRepository editEmployeeRepository(EditEmployeeRepositoryRef ref) {
  return EditEmployeeRepository(dio: ref.watch(dioProvider));
}
