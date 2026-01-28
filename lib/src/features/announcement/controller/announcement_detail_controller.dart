import 'package:hr_app/src/features/announcement/data/announcement_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcement_detail_controller.g.dart';

@riverpod
class AnnouncementDetailController extends _$AnnouncementDetailController {
  bool _mounted = true;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => _mounted = false);
  }

  Future<bool> announcementGotIt(int announcementId) async {
    final announcementDetailRepo = ref.read(announcementRepositoryProvider);
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => announcementDetailRepo.announcementGotIt(announcementId));
    if (_mounted) {
      state = result;
    }

    return state.hasError == false;
  }
}
