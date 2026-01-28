import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/announcement/model/announcement_detail_response.dart';
import 'package:hr_app/src/features/announcement/model/announcement_response.dart';
import 'package:hr_app/src/features/holiday/model/holiday_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../home/model/attendance_response.dart';

part 'announcement_repository.g.dart';

class AnnouncementRepository {
  AnnouncementRepository({required this.dio,required this.ref});

  final Dio dio;
  final Ref ref;


  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));



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

  Future<void> announcementGotIt(int announcementId) async {
    final res = await _dioV2.post(
      kEndPointAnnouncementGotIt,
      data: {"announcement_id":announcementId},
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

  ///fetch employee profile
  Future<AnnouncementDetailResponse> fetchAnnouncementDetailByID({
    required int announcementID,
  }) async {
    try {
      final response = await _dioV2.get(
        "$kEndPointAnnouncementDetails/$announcementID",);
      AnnouncementDetailResponse data = AnnouncementDetailResponse.fromJson(
        response.data,
      );
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
AnnouncementRepository announcementRepository(AnnouncementRepositoryRef ref) {
  return AnnouncementRepository(dio: ref.watch(dioProvider()),ref: ref);
}

@riverpod
Future<AnnouncementResponse> fetchAnnouncements(
    FetchAnnouncementsRef ref,{int? businessUnitId}
    ) async {
  final provider = ref.watch(announcementRepositoryProvider);
  return provider.fetchAnnouncementData(businessUnitId: businessUnitId);
}

@riverpod
Future<AnnouncementDetailResponse> fetchAnnouncementDetailByID(
    FetchAnnouncementDetailByIDRef ref, {
      required int announcementID,
    }) async {
  final provider = ref.watch(announcementRepositoryProvider);
  return provider.fetchAnnouncementDetailByID(announcementID: announcementID);
}

