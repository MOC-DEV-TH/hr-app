import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../home/model/attendance_response.dart';

part 'add_new_employee_repository.g.dart';

class AddNewEmployeeRepository {
  AddNewEmployeeRepository({required this.dio});

  final Dio dio;

}

@riverpod
AddNewEmployeeRepository addNewEmployeeRepository(AddNewEmployeeRepositoryRef ref) {
  return AddNewEmployeeRepository(dio: ref.watch(dioProvider));
}
