import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_in_controller.g.dart';

@riverpod
class CheckInController extends _$CheckInController {
  bool mounted = true;

  @override
  FutureOr<void> build() {}

  Future<bool> checkIn({required type,}) async {
    final homeRepository = ref.read(homeRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() =>
        homeRepository.checkIn(
          type: type,
        ));
        if (mounted)
    {
      state = result;
    }

    return state.hasError == false;
  }
}