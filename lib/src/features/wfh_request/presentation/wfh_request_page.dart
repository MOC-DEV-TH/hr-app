import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/wfh_request_successful_dialog.dart';

class WfhRequestPage extends StatefulWidget {
  const WfhRequestPage({Key? key}) : super(key: key);

  @override
  State<WfhRequestPage> createState() => _WfhRequestPageState();
}

class _WfhRequestPageState extends State<WfhRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _wfhDoesNotAffectOps = false;

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
        _dateController.text = '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  void _onSave() async{
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Hook up to API or local state
      final payload = {
        'date': _dateController.text,
        'message': _messageController.text,
        'doesNotAffectOps': _wfhDoesNotAffectOps,
      };

      /// For now just show a dialog
      await wfhRequestSuccessDialog(
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminCustomAppBarView(title: 'WFH Request', isShowRightIcon: false),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Date', style: TextStyle(color: Color(0xFF4B5563), fontSize: 14)),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                        if (v == null || v.isEmpty) return 'Please pick a date';
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                const Text('Message', style: TextStyle(color: Color(0xFF4B5563), fontSize: 14)),
                const SizedBox(height: 8),

                /// Message box
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  minLines: 4,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                ),

                const SizedBox(height: 14),

                /// Long label with switch on the right
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Proposed work from home schedule will not affect the operation negatively?',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                      ),
                    ),
                    Switch(
                      value: _wfhDoesNotAffectOps,
                      onChanged: (v) => setState(() => _wfhDoesNotAffectOps = v),
                      activeColor: Colors.white,
                      activeTrackColor: Colors.blue.shade400,
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// Save button - full width rounded
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E90F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),

                /// Spacer to push content to top like the screenshot
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
