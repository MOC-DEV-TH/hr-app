import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';

part 'edit_employee_repository.g.dart';

class EditEmployeeRepository {
  EditEmployeeRepository({required this.dio});

  final Dio dio;

  Future<void> updateEmployee(dynamic payload) async {
    final formData = FormData.fromMap(payload);

    final res = await dio.post(
      kEndPointUpdateEmployee,
      data: formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        followRedirects: false,
        validateStatus: (s) => s != null && s < 500,
      ),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Failed with status ${res.statusCode}',
      );
    }
  }

}

@riverpod
EditEmployeeRepository editEmployeeRepository(EditEmployeeRepositoryRef ref) {
  return EditEmployeeRepository(dio: ref.watch(dioProvider));
}
