import 'dart:async';

import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_out_controller.g.dart';

@riverpod
class CheckOutController extends _$CheckOutController {
  bool _isDisposed = false;

  @override
  FutureOr<void> build() {
    _isDisposed = false;

    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  Future<bool> checkOut({
    String? reason,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = const AsyncValue.loading();

    try {
      final success = await ref
          .read(homeRepositoryProvider)
          .checkOut(
        reason: reason,
      );

      if (_isDisposed) {
        return false;
      }

      state = const AsyncValue.data(null);

      return success;
    } catch (error, stackTrace) {
      if (_isDisposed) {
        return false;
      }

      state = AsyncValue.error(
        error,
        stackTrace,
      );

      return false;
    }
  }
}