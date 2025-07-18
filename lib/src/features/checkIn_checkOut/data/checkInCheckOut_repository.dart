import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';

part 'checkInCheckOut_repository.g.dart';

class CheckInCheckOutRepository {
  CheckInCheckOutRepository({required this.dio});

  final Dio dio;

///to do api
}

@riverpod
CheckInCheckOutRepository checkInCheckOutRepository(CheckInCheckOutRepositoryRef ref) {
  return CheckInCheckOutRepository(dio: ref.watch(dioProvider));
}
