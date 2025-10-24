import 'package:hr_app/src/features/employee_leaves/data/employee_leaves_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_leaves_controller.g.dart';

@riverpod
class EmployeeLeavesController extends _$EmployeeLeavesController {
  bool mounted = true;

  @override
  FutureOr<void> build() {
    /// * this code is for  preventing error caused by popping out or going to other screen while the app is sending api request
    ref.onDispose(() => mounted = false);
  }

  Future<bool> updateLeaveRequest({
    required int leaveId,
    required String leaveStatus,
  }) async {
    final employeeLeavesRepository = ref.read(employeeLeavesRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => employeeLeavesRepository.updateEmployeeLeaveRequest(
        leaveId: leaveId,
        status: leaveStatus,
      ),
    );
    if (mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
