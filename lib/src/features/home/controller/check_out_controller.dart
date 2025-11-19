import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_out_controller.g.dart';

@riverpod
class CheckOutController extends _$CheckOutController {
  bool mounted = true;

  @override
  FutureOr<void> build() {}

  Future<bool> checkOut({String? reason}) async {
    state = const AsyncLoading();

    final repo = ref.read(homeRepositoryProvider);
    final result = await AsyncValue.guard(() => repo.checkOut(reason: reason));
    if (!mounted) return false;
    state = result;
    
    return !result.hasError;
  }


}