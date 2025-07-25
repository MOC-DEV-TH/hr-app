import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/dynamic_drop_down_widget.dart';
import 'package:hr_app/src/features/leave_request/controller/send_leave_request_controller.dart';
import 'package:hr_app/src/features/leave_request/data/leave_request_repository.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/loading_view.dart';

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
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///states
    final leaveTypesState = ref.watch(fetchLeaveTypesDataProvider);
    final sendLeaveRequestState = ref.watch(sendLeaveRequestControllerProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBarView(title: 'Leave Request'),
      body: Stack(
        children: [
          ///body view
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kMarginXXLarge),
              child: leaveTypesState.when(
                data: (leaveTypesData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///date text form
                      Text('Date', style: TextStyle(fontSize: kTextRegular2x)),
                      10.vGap,
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Choose Date',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),

                      20.vGap,

                      ///leave type dropdown
                      Text(
                        'Leave Type',
                        style: TextStyle(fontSize: kTextRegular2x),
                      ),
                      10.vGap,
                      SizedBox(
                        height: 60,
                        child: DynamicDropDownWidget(
                          hintText: 'Choose Leave Type',
                          items: leaveTypesData.data,
                          onSelect: (value) {
                            setState(() {
                              leaveType = value.id;
                            });
                            debugPrint("LeaveType::::::>>>>${value.id}");
                          },
                        ),
                      ),

                      20.vGap,

                      ///message text form
                      Text('Message', style: TextStyle(fontSize: kTextRegular2x)),
                      10.vGap,
                      TextFormField(
                        maxLines: 5,
                        controller: _messageController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Type reason for leave',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),

                      34.vGap,

                      ///send button
                      SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: 'Send',
                          onTap: () async {
                            final bool isSuccess = await ref
                                .read(sendLeaveRequestControllerProvider.notifier)
                                .sendLeaveRequest(
                                  date: _dateController.text,
                                  leaveType: leaveType,
                                  message: _messageController.text,
                                );

                            ///is success
                            if (isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✅ Leave request sent.!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green[700],
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            }
                          },
                          bgColor: kPrimaryColor,
                          buttonTextColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                error: (Object error, StackTrace stackTrace) {
                  return Container();
                },
              ),
            ),
          ),

          ///loading view
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
