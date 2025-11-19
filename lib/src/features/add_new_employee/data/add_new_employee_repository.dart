import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';

part 'add_new_employee_repository.g.dart';

class AddNewEmployeeRepository {
  AddNewEmployeeRepository({required this.dio});

  final Dio dio;

  Future<void> createEmployee(dynamic payload) async {
    final res = await dio.post(
      kEndPointCreateEmployee,
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
      data: payload,
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
AddNewEmployeeRepository addNewEmployeeRepository(AddNewEmployeeRepositoryRef ref) {
  return AddNewEmployeeRepository(dio: ref.watch(dioProvider));
}
