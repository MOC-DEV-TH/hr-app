import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/add_new_employee/controller/add_new_employee_controller.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/admin_custom_app_bar_view.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../utils/colors.dart';

class AddNewEmployeePage extends ConsumerStatefulWidget {
  const AddNewEmployeePage({super.key});

  @override
  ConsumerState<AddNewEmployeePage> createState() => _AddNewEmployeePageState();
}

class _AddNewEmployeePageState extends ConsumerState<AddNewEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  /// controllers
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  /// chosen values
  String? _country;
  String? _businessUnit;
  String? _department;
  String? _position;
  String? _role;
  String? _employeeType;

  /// toggles
  bool _isDeptHead = false;
  bool _allowRemote = false;
  bool _active = false;

  /// ui
  bool _obscured = true;

  /// sample data (plug your API data here)
  final _countries = const ['Myanmar', 'Thailand', 'Singapore', 'Vietnam'];
  final _businessUnits = const ['BU A', 'BU B', 'BU C'];
  final _departments = const ['Engineering', 'HR', 'Finance', 'Marketing'];
  final _positions = const ['Junior', 'Mid', 'Senior', 'Lead'];
  final _roles = const ['User', 'Manager', 'Admin'];
  final _employeeTypes = const ['Full-time', 'Part-time', 'Contractor', 'Intern'];

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<T?> _pickOne<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No options available')),
      );
      return Future.value(null);
    }

    final tt = Theme.of(context).textTheme;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ...items.map(
                    (e) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: itemBuilder(e),
                  onTap: () => Navigator.of(ctx).pop<T>(e),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (_country == null ||
        _businessUnit == null ||
        _department == null ||
        _position == null ||
        _role == null ||
        _employeeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all selections.')),
      );
      return;
    }

    /// Collect the payload here
    final payload = {
      'full_name': _fullNameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'country': _country,
      'business_unit': _businessUnit,
      'department': _department,
      'position': _position,
      'role': _role,
      'employee_type': _employeeType,
      'email': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'is_department_head': _isDeptHead,
      'allow_remote_login': _allowRemote,
      'active': _active,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Employee saved')),
    );
    Navigator.pop(context, payload);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final state = ref.watch(addNewEmployeeControllerProvider);

    ///show error dialog when network response error
    ref.listen<AsyncValue>(
      addNewEmployeeControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminCustomAppBarView(title: 'Add New Employee',bgColor: Colors.white,isShowRightIcon: false,),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                /// Profile Picture block (no green circle)
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: cs.surfaceVariant,
                              borderRadius: BorderRadius.circular(96),
                            ),
                            child: const Icon(Icons.person, size: 44),
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: InkWell(
                              onTap: () {
                                // TODO: open image picker if you want (optional)
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(Icons.edit, size: 16, color: cs.onPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Profile Picture',
                          style: tt.bodySmall?.copyWith(color: cs.outline)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Full name
                LabeledInput(
                  label: 'Full Name',
                  controller: _fullNameCtrl,
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
                ),

                const SizedBox(height: 12),

                /// Phone number
                LabeledInput(
                  label: 'Phone Number',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
                ),

                const SizedBox(height: 12),

                /// Country
                LabeledSelect(
                  label: 'Country',
                  valueText: _country ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Country',
                      items: _countries,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _country = v);
                  },
                ),

                const SizedBox(height: 12),

                /// Business Unit
                LabeledSelect(
                  label: 'Business Unit',
                  valueText: _businessUnit ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Business Unit',
                      items: _businessUnits,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _businessUnit = v);
                  },
                ),

                const SizedBox(height: 12),

                /// Department
                LabeledSelect(
                  label: 'Department',
                  valueText: _department ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Department',
                      items: _departments,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _department = v);
                  },
                ),

                const SizedBox(height: 12),

                /// Position
                LabeledSelect(
                  label: 'Position',
                  valueText: _position ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Position',
                      items: _positions,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _position = v);
                  },
                ),

                const SizedBox(height: 12),

                /// Role
                LabeledSelect(
                  label: 'Role',
                  valueText: _role ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Role',
                      items: _roles,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _role = v);
                  },
                ),

                const SizedBox(height: 30),
                Row(children: [
                  const SectionLabel(text: 'Login Account'),
                  20.hGap,
                  Expanded(child: Container(color: Colors.grey,height: 1,))
                ],),
                const SizedBox(height: 18),

                /// Employee Type
                LabeledSelect(
                  label: 'Employee Type',
                  valueText: _employeeType ?? 'Choose',
                  onTap: () async {
                    final v = await _pickOne<String>(
                      title: 'Select Employee Type',
                      items: _employeeTypes,
                      itemBuilder: (e) => Text(e),
                    );
                    if (v != null) setState(() => _employeeType = v);
                  },
                ),

                const SizedBox(height: 12),

                /// Email
                LabeledInput(
                  label: 'Email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'Required';
                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
                    return ok ? null : 'Invalid email';
                  },
                ),

                const SizedBox(height: 12),

                /// Password
                LabeledInput(
                  label: 'Password',
                  controller: _passwordCtrl,
                  obscureText: _obscured,
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                  suffix: IconButton(
                    icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  ),
                ),

                const SizedBox(height: 18),

                LabeledSwitch(
                  label: 'Department Head',
                  value: _isDeptHead,
                  onChanged: (v) => setState(() => _isDeptHead = v),
                ),
                const SizedBox(height: 12),
                LabeledSwitch(
                  label: 'Allow Remote Login',
                  value: _allowRemote,
                  onChanged: (v) => setState(() => _allowRemote = v),
                ),
                const SizedBox(height: 12),
                LabeledSwitch(
                  label: 'Active',
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: 'Save',
                    onTap: () async {
                      _save();
                    },
                    bgColor: kBlueColor,
                    buttonTextColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          ///loading view
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
    );
  }
}

/// ───────────── Common Widgets ─────────────

class LabeledInput extends StatelessWidget {
  const LabeledInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: tt.labelLarge?.copyWith(
              color: cs.outline,
              fontWeight: FontWeight.w600,
            )),
        4.vGap,
        Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.03),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              isDense: true,
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledSelect extends StatelessWidget {
  const LabeledSelect({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: tt.labelLarge?.copyWith(
                color: cs.outline,
                fontWeight: FontWeight.w600,
              )),
          4.vGap,
          Ink(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(valueText, style: tt.titleMedium),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Transform.scale(
            scale: .85,
            alignment: Alignment.centerRight,
            child: Switch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: tt.bodySmall?.copyWith(
        color: cs.outline,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
