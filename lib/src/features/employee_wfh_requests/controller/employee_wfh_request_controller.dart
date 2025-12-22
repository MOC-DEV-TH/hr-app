import 'package:hr_app/src/features/employee_leaves/data/employee_leaves_repository.dart';
import 'package:hr_app/src/features/employee_wfh_requests/data/employees_wfh_requests_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_wfh_request_controller.g.dart';

@riverpod
class EmployeeWfhRequestController extends _$EmployeeWfhRequestController {
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
    final employeeWfhRequestRepository = ref.read(employeesWfhRequestsRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => employeeWfhRequestRepository.updateEmployeeWfhRequest(
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
