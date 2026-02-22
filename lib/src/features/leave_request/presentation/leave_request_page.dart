import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/dynamic_drop_down_widget.dart';
import 'package:hr_app/src/features/leave_request/controller/send_leave_request_controller.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/leave_request_successful_dialog.dart';
import '../../../common_widgets/loading_view.dart';
import '../../admin_dashboard/data/admin_dashboard_repository.dart';
import '../data/leave_request_repository.dart';

enum LeaveDayType { fullDay, halfDay }

enum LeavePeriod { morning, afternoon }

class LeaveRequestPage extends ConsumerStatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  ConsumerState<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends ConsumerState<LeaveRequestPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  DateTime? _selectedDate;
  int? leaveType;

  LeaveDayType _leaveDayType = LeaveDayType.fullDay;
  LeavePeriod? _leavePeriod;

  /// used to force rebuild dropdown to its initial state after success
  int _dropdownResetToken = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _resetForm() {
    setState(() {
      _selectedDate = null;
      leaveType = null;
      _leaveDayType = LeaveDayType.fullDay;
      _leavePeriod = null;
      _dateController.clear();
      _messageController.clear();
      _dropdownResetToken++;
    });
  }

  double get _leaveDayValue =>
      _leaveDayType == LeaveDayType.fullDay ? 1.0 : 0.5;

  @override
  void dispose() {
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///show error dialog when network response error
    ref.listen<AsyncValue>(
      sendLeaveRequestControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final leaveTypesState = ref.watch(fetchLeaveTypesDataProvider);
    final sendLeaveRequestState = ref.watch(sendLeaveRequestControllerProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const AdminCustomAppBarView(
        title: 'Leave Request',
        isShowRightIcon: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kMarginXLarge),
              child: leaveTypesState.when(
                data: (leaveTypesData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Date
                      Text('Date', style: TextStyle(fontSize: kTextRegular2x)),
                      10.vGap,
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'DD/MM/YYYY',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),

                      20.vGap,

                      /// Leave Type
                      Text(
                        'Leave Type',
                        style: TextStyle(fontSize: kTextRegular2x),
                      ),
                      10.vGap,
                      SizedBox(
                        height: 60,
                        child: DynamicDropDownWidget(
                          key: ValueKey(_dropdownResetToken),
                          hintText: 'Choose',
                          items: leaveTypesData.data,
                          onSelect: (value) {
                            setState(() => leaveType = value.id);
                          },
                        ),
                      ),

                      20.vGap,

                      /// Full Day / Half Day segmented toggle
                      _LeaveDayToggle(
                        value: _leaveDayType,
                        onChanged: (v) {
                          setState(() {
                            _leaveDayType = v;
                            if (_leaveDayType == LeaveDayType.fullDay) {
                              _leavePeriod = null;
                            }
                          });
                        },
                      ),

                      16.vGap,

                      /// Half-day period dropdown (Morning/Afternoon)
                      if (_leaveDayType == LeaveDayType.halfDay) ...[
                        Text(
                          'Select Period',
                          style: TextStyle(fontSize: kTextRegular2x),
                        ),
                        10.vGap,
                        SizedBox(
                          height: 60,
                          child: DropdownButtonFormField<LeavePeriod>(
                            value: _leavePeriod,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: 'Choose',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: LeavePeriod.morning,
                                child: Text('Morning'),
                              ),
                              DropdownMenuItem(
                                value: LeavePeriod.afternoon,
                                child: Text('Afternoon'),
                              ),
                            ],
                            onChanged: (v) => setState(() => _leavePeriod = v),
                          ),
                        ),
                        16.vGap,
                      ],

                      /// Leave Day value
                      Row(
                        children: [
                          Text(
                            'Leave Day : ',
                            style: TextStyle(fontSize: kTextRegular2x),
                          ),
                          Text(
                            _leaveDayValue == 1.0 ? '1' : '0.5',
                            style: TextStyle(
                              fontSize: kTextRegular2x,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      16.vGap,

                      /// Message
                      Text(
                        'Message',
                        style: TextStyle(fontSize: kTextRegular2x),
                      ),
                      10.vGap,
                      TextFormField(
                        maxLines: 5,
                        controller: _messageController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Type reason for leave',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),

                      34.vGap,

                      /// Save button
                      SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: 'Save',
                          onTap: () async {
                            /// validations
                            if (_dateController.text.isEmpty) {
                              context.showErrorSnackBar('Please select date');
                              return;
                            }
                            if (leaveType == null) {
                              context.showErrorSnackBar(
                                'Please select leave type',
                              );
                              return;
                            }
                            if (_leaveDayType == LeaveDayType.halfDay &&
                                _leavePeriod == null) {
                              context.showErrorSnackBar(
                                'Please select period (Morning/Afternoon)',
                              );
                              return;
                            }
                            if (_messageController.text.isEmpty) {
                              context.showErrorSnackBar(
                                'Please type the reason for leave.',
                              );
                              return;
                            }

                            final bool isSuccess = await ref
                                .read(
                                  sendLeaveRequestControllerProvider.notifier,
                                )
                                .sendLeaveRequest(
                                  date: _dateController.text,
                                  leaveType: leaveType,
                                  message: _messageController.text,
                                  halfDay : _leaveDayValue == 1.0 ? 0 : 1,
                                  period: _leavePeriod?.name,
                                );

                            if (!mounted) return;

                            if (isSuccess) {
                              _resetForm();
                              ref.invalidate(fetchAdminDashboardDataProvider);
                              await leaveRequestSuccessDialog(context);
                            }
                          },
                          bgColor: kPrimaryColor,
                          buttonTextColor: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),

          /// Loading overlay
          if (sendLeaveRequestState.isLoading)
            Container(
              color: Colors.black12,
              child: const Center(
                child: LoadingView(
                  indicatorColor: Colors.white,
                  indicator: Indicator.ballRotate,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LeaveDayToggle extends StatelessWidget {
  const _LeaveDayToggle({required this.value, required this.onChanged});

  final LeaveDayType value;
  final ValueChanged<LeaveDayType> onChanged;

  @override
  Widget build(BuildContext context) {
    final isFull = value == LeaveDayType.fullDay;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: kSoftYellow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(LeaveDayType.fullDay),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isFull ? kSecondaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Full Day',
                  style: TextStyle(
                    color: isFull ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(LeaveDayType.halfDay),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: !isFull ? kSecondaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Half Day',
                  style: TextStyle(
                    color: !isFull ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
