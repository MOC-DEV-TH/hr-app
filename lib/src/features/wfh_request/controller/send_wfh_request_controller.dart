import 'package:hr_app/src/features/wfh_request/data/wfh_request_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_wfh_request_controller.g.dart';

@riverpod
class SendWfhRequestController extends _$SendWfhRequestController {
  bool mounted = true;

  @override
  FutureOr<void> build() {}

  Future<bool> sendWfhRequest(payload) async {
    final wfhRequestRepository = ref.read(wfhRequestRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
          () => wfhRequestRepository.sendWfhRequest(payload),
    );
    if (mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
