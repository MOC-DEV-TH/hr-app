import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/wfh_request_successful_dialog.dart';
import 'package:hr_app/src/features/admin_dashboard/data/admin_dashboard_repository.dart';
import 'package:hr_app/src/features/wfh_request/controller/send_wfh_request_controller.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../utils/secure_storage.dart';

class WfhRequestPage extends ConsumerStatefulWidget {
  const WfhRequestPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WfhRequestPage> createState() => _WfhRequestPageState();
}

class _WfhRequestPageState extends ConsumerState<WfhRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _wfhDoesNotAffectOps = false;
  var selectedDate = DateTime.now();

  @override
  void dispose() {
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  void onSave({required int id, required String name}) async {
    if (_formKey.currentState?.validate() ?? false) {
      final payload = {
        "user_id": id,
        "wfh_date": selectedDate.ymd(),
        "name": name,
        "message": _messageController.text,
        "affect_operation": _wfhDoesNotAffectOps == false ? 'No' : 'Yes',
      };
      final ok = await ref
          .read(sendWfhRequestControllerProvider.notifier)
          .sendWfhRequest(payload);
      if (!mounted) return;
      if (ok) {
        await wfhRequestSuccessDialog(context);
        ref.invalidate(fetchAdminDashboardDataProvider);
        _messageController.clear();
        _dateController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sendWfhRequestControllerProvider);
    var userName = ref.watch(getUserDataProvider).value?.name;
    var id = ref.watch(getUserDataProvider).value?.id;

    /// show error dialog when network response error
    ref.listen<AsyncValue>(
      sendWfhRequestControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    return Scaffold(
      appBar: AdminCustomAppBarView(
        title: 'WFH Request',
        isShowRightIcon: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              hintText: 'DD/MM/YYYY',
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: Icon(Icons.calendar_today_outlined),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade300,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Please pick a date';
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'Message',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Message box
                      TextFormField(
                        controller: _messageController,
                        maxLines: 6,
                        minLines: 4,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Please enter message';
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      /// Long label with switch on the right
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Proposed work from home schedule will not affect the operation negatively?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          Switch(
                            value: _wfhDoesNotAffectOps,
                            onChanged:
                                (v) => setState(() => _wfhDoesNotAffectOps = v),
                            activeColor: Colors.white,
                            activeTrackColor: kPrimaryColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      /// Save button - full width rounded
                      SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          containerVPadding: 10,
                          bgColor: kPrimaryColor,
                          buttonTextColor: kSecondaryOlive,
                          text: 'Save', onTap: () {
                          onSave(
                              id: id ?? 0,
                              name: userName ?? ''
                          );
                        },),
                      ),
                      /// Spacer to push content to top like the screenshot
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// loading view for submit
              if (state.isLoading)
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
        ),
      ),
    );
  }
}
