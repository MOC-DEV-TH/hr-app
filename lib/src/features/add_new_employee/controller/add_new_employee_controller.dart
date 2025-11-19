import 'dart:io';

import 'package:hr_app/src/features/add_new_employee/data/add_new_employee_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_new_employee_controller.g.dart';

@riverpod
class AddNewEmployeeController extends _$AddNewEmployeeController {
  bool _mounted = true;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => _mounted = false);
  }

  Future<bool> createEmployee(dynamic payload) async {
    final addNewEmployeeRepo = ref.read(addNewEmployeeRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
          () => addNewEmployeeRepo.createEmployee(payload),
    );
    if (_mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
