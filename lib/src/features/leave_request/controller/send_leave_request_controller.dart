import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:hr_app/src/features/leave_request/data/leave_request_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_leave_request_controller.g.dart';

@riverpod
class SendLeaveRequestController extends _$SendLeaveRequestController {
  bool mounted = true;

  @override
  FutureOr<void> build() {}

  Future<bool> sendLeaveRequest({
    required date,
    required leaveType,
    required message,
  }) async {
    final leaveRequestRepository = ref.read(leaveRequestRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => leaveRequestRepository.sendLeaveRequest(
        date: date,
        leaveType: leaveType,
        message: message,
      ),
    );
    if (mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
