import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/announcement/model/announcement_response.dart';
import 'package:hr_app/src/features/holiday/model/holiday_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../home/model/attendance_response.dart';

part 'announcement_repository.g.dart';

class AnnouncementRepository {
  AnnouncementRepository({required this.dio});

  final Dio dio;


  ///get all announcement data
  Future<AnnouncementResponse> fetchAnnouncementData({int? businessUnitId}) async {
    try {
      final response = await dio.get(
        kEndPointAnnouncementList,
        queryParameters: businessUnitId != null
            ? {'business_unit': businessUnitId}
            : null,
      );

      final data = AnnouncementResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
AnnouncementRepository announcementRepository(AnnouncementRepositoryRef ref) {
  return AnnouncementRepository(dio: ref.watch(dioProvider()));
}

@riverpod
Future<AnnouncementResponse> fetchAnnouncements(
    FetchAnnouncementsRef ref,{int? businessUnitId}
    ) async {
  final provider = ref.watch(announcementRepositoryProvider);
  return provider.fetchAnnouncementData(businessUnitId: businessUnitId);
}


