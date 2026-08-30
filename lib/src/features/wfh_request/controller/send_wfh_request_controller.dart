import 'package:flutter/material.dart';
import 'package:hr_app/src/features/wfh_request/data/wfh_request_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_wfh_request_controller.g.dart';

@riverpod
class SendWfhRequestController extends _$SendWfhRequestController {
  @override
  FutureOr<void> build() {}

  Future<bool> sendWfhRequest(
      Map<String, dynamic> payload,
      ) async {
    final repository = ref.read(
      wfhRequestRepositoryProvider,
    );

    state = const AsyncValue.loading();

    try {
      await repository.sendWfhRequest(payload);

      debugPrint('✅ REPOSITORY FINISHED SUCCESSFULLY');

      state = const AsyncValue.data(null);

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ CONTROLLER CATCH');
      debugPrint('ERROR = $e');
      debugPrint('STACK = $stackTrace');

      state = AsyncValue.error(
        e,
        stackTrace,
      );

      return false;
    }
  }
}