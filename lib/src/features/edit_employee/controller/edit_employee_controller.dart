import 'package:hr_app/src/features/edit_employee/data/edit_employee_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_employee_controller.g.dart';

@riverpod
class EditEmployeeController extends _$EditEmployeeController {
  bool _mounted = true;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => _mounted = false);
  }

  Future<bool> updateEmployee(dynamic payload,String employeeId) async {
    final editEmployeeRepo = ref.read(editEmployeeRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => editEmployeeRepo.updateEmployee(payload,employeeId));
    if (_mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
