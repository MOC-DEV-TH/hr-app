import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';

part 'leave_status_repository.g.dart';

class LeaveStatusRepository {
  LeaveStatusRepository({required this.dio});

  final Dio dio;

  ///fetch leave status
}

@riverpod
LeaveStatusRepository leaveStatusRepository(LeaveStatusRepositoryRef ref) {
  return LeaveStatusRepository(dio: ref.watch(dioProvider));
}
