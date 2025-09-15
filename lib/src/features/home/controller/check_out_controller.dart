import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_out_controller.g.dart';

@riverpod
class CheckOutController extends _$CheckOutController {
  bool mounted = true;

  @override
  FutureOr<void> build() {}

  Future<bool> checkOut({String? reason}) async {
    final homeRepository = ref.read(homeRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() =>
        homeRepository.checkOut());
        if (mounted)
    {
      state = result;
    }

    return state.hasError == false;
  }
}