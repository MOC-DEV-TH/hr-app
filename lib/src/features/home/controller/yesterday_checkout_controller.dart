import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/home_repository.dart';

part 'yesterday_checkout_controller.g.dart';

@riverpod
class YesterdayCheckoutController
    extends _$YesterdayCheckoutController {
  @override
  FutureOr<void> build() {}

  Future<bool> updateYesterdayCheckout({
    required int userId,
    required String time,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = const AsyncLoading();

    try {
      final success = await ref
          .read(homeRepositoryProvider)
          .updateYesterdayCheckout(
        userId: userId,
        time: time,
      );

      state = const AsyncData(null);

      return success;
    } catch (error, stackTrace) {
      debugPrint(
        'Yesterday checkout controller error: $error',
      );

      state = AsyncError(
        error,
        stackTrace,
      );

      return false;
    }
  }
}