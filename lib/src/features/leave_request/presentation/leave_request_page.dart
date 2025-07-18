import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/dynamic_drop_down_widget.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDate;

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
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  var
  dropdownDummyData = [
    {"id": "1", "name": "Leave Request One"},
    {"id": "2", "name": "Leave Request Two"},
    {"id": "3", "name": "Leave Request Three"}
  ];


  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBarView(title: 'Leave Request'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kMarginXXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///date text form
              Text('Date',style: TextStyle(fontSize: kTextRegular2x),),
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
              Text('Leave Type',style: TextStyle(fontSize: kTextRegular2x),),
              10.vGap,
              SizedBox(
                  height: 60,
                  child: DynamicDropDownWidget(
                      hintText: 'Choose Leave Type',
                      items: dropdownDummyData, onSelect: (value){})),

              20.vGap,

              ///message text form
              Text('Message',style: TextStyle(fontSize: kTextRegular2x),),
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
                    text: 'Send', onTap: (){},bgColor: kPrimaryColor,buttonTextColor: Colors.white,))
            ],
          ),
        ),
      ),
    );
  }
}
