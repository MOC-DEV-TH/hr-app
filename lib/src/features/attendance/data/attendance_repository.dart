import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';

part 'attendance_repository.g.dart';

class AttendanceRepository {
  AttendanceRepository({required this.dio});

  final Dio dio;

///to do api
}

@riverpod
AttendanceRepository attendanceRepository(AttendanceRepositoryRef ref) {
  return AttendanceRepository(dio: ref.watch(dioProvider));
}
