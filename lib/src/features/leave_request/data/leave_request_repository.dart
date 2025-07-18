import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';

part 'leave_request_repository.g.dart';

class LeaveRequestRepository {
  LeaveRequestRepository({required this.dio});

  final Dio dio;

///to do api
}

@riverpod
LeaveRequestRepository leaveRequestRepository(LeaveRequestRepositoryRef ref) {
  return LeaveRequestRepository(dio: ref.watch(dioProvider));
}
