import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/admin_dashboard/model/employee_dropdown_response.dart';
import 'package:hr_app/src/features/edit_employee/controller/edit_employee_controller.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/labeled_input.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../common_widgets/section_label.dart';
import '../../employee_details/data/employee_details_repository.dart';
import '../../employee_details/model/employee_profile_response.dart';
import '../../../utils/secure_storage.dart';

/// ---------------- Common micro-widgets ----------------

class SelectTile<T> extends StatelessWidget {
  const SelectTile({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.bodySmall?.copyWith(color: cs.outline)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText == null ? cs.outlineVariant : cs.error,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    valueText.isEmpty ? 'Choose' : valueText,
                    style: tt.bodyMedium?.copyWith(
                      color: valueText.isEmpty ? cs.outline : null,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, color: cs.outline),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: tt.bodySmall?.copyWith(color: cs.error)),
        ],
      ],
    );
  }
}

Future<T?> pickOne<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Widget Function(T) itemBuilder,
}) async {
  if (items.isEmpty) return null;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder:
        (ctx) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            shrinkWrap: true,
            children: [
              Text(
                title,
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (e) => ListTile(
                  title: itemBuilder(e),
                  onTap: () => Navigator.of(ctx).pop<T>(e),
                ),
              ),
            ],
          ),
        ),
  );
}

/// Multi-select bottom sheet
Future<List<T>?> pickMany<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Widget Function(T) itemBuilder,
  required bool Function(T) isInitiallySelected,
  required Object? Function(T) getId,
}) async {
  if (items.isEmpty) return null;

  final tt = Theme.of(context).textTheme;

  return showModalBottomSheet<List<T>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) {
      final selectedIds = <Object?>{
        for (final e in items)
          if (isInitiallySelected(e)) getId(e),
      };

      List<T> currentSelected() =>
          items.where((e) => selectedIds.contains(getId(e))).toList();

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...items.map((e) {
                            final id = getId(e);
                            final isSelected = selectedIds.contains(id);
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              leading: Icon(
                                isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                              ),
                              title: itemBuilder(e),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedIds.remove(id);
                                  } else {
                                    selectedIds.add(id);
                                  }
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop<List<T>?>(null),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () =>
                              Navigator.of(ctx).pop<List<T>>(currentSelected()),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// ---------------- Edit page using ProfileVO + local dropdowns ----------------
class EditEmployeePage extends ConsumerStatefulWidget {
  const EditEmployeePage({super.key, required this.profile});

  final ProfileVO profile;

  @override
  ConsumerState<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends ConsumerState<EditEmployeePage> {
  /// Form key
  final _formKey = GlobalKey<FormState>();

  /// Controllers
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  /// Selected IDs
  int? _countryId;
  int? _buId;
  List<int> _deptIds = [];
  int? _posId;
  int? _roleId;
  int? _empTypeId;

  /// Dropdown error texts
  String? _countryError;
  String? _buError;
  String? _deptError;
  String? _posError;
  String? _roleError;
  String? _empTypeError;

  bool _isDeptHead = false;
  bool _allowRemote = false;
  bool _active = true;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _name.text = p.name ?? '';
    _phone.text = p.phone ?? '';
    _email.text = p.email ?? '';

    _countryId = p.countryId;
    _buId = p.bussinessUnitId;
    _deptIds = (p.departmentId ?? []).whereType<int>().toList();
    _posId = p.positionId;
    _roleId = p.role;
    _empTypeId = p.employeeTypeId;

    _isDeptHead = p.isDepartmentHead == 1 || p.isDepartmentHead == true;
    _allowRemote = p.allowRemoteLogin == 1 || p.allowRemoteLogin == true;
    _active = p.active == true;
  }

  /// Resolve id → name
  String labelFor(List<IDNameVO> list, int? id) {
    if (id == null) return '';
    final match = list.firstWhere(
      (e) => e.id == id,
      orElse: () => IDNameVO(id: 0, name: ''),
    );
    return match.name ?? '';
  }

  /// Multi id → "Name1, Name2"
  String multiLabelFor(List<IDNameVO> list, List<int> ids) {
    if (ids.isEmpty) return '';
    final names = <String>[];
    for (final id in ids) {
      final match = list.firstWhere(
        (e) => e.id == id,
        orElse: () => IDNameVO(id: 0, name: ''),
      );
      final name = match.name ?? '';
      if (name.isNotEmpty) names.add(name);
    }
    return names.join(', ');
  }

  Future<void> _save() async {
    /// Validate text fields
    final formOk = _formKey.currentState?.validate() ?? false;

    /// Validate dropdowns
    setState(() {
      _countryError = _countryId == null ? 'Required' : null;
      _buError = _buId == null ? 'Required' : null;
      _deptError = _deptIds.isEmpty ? 'Required' : null;
      _posError = _posId == null ? 'Required' : null;
      _roleError = _roleId == null ? 'Required' : null;
      _empTypeError = _empTypeId == null ? 'Required' : null;
    });

    final dropdownOk = [
      _countryError,
      _buError,
      _deptError,
      _posError,
      _roleError,
      _empTypeError,
    ].every((e) => e == null);

    if (!formOk || !dropdownOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final payload = {
      'id': widget.profile.id,
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim(),
      if (_password.text.isNotEmpty) 'password': _password.text,
      'country_id': _countryId,
      'bussiness_unit_id': _buId,
      'department_id': _deptIds,
      'position_id': _posId,
      'role': _roleId,
      'employee_type_id': _empTypeId,
      'is_department_head': _isDeptHead ? 1 : 0,
      'allow_remote_login': _allowRemote ? 1 : 0,
      'active': _active ? 1 : 0,
    };

    final ok = await ref
        .read(editEmployeeControllerProvider.notifier)
        .updateEmployee(payload,widget.profile.id.toString());
    if (!mounted) return;
    if (ok) ref.invalidate(fetchEmployeeProfileDataProvider);
    if (ok) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    /// Load local dropdowns
    final countries = ref.watch(countriesLocalProvider).value ?? [];
    final businessUnits = ref.watch(businessUnitsLocalProvider).value ?? [];
    final departments = ref.watch(departmentsLocalProvider).value ?? [];
    final positions = ref.watch(positionsLocalProvider).value ?? [];
    final roles = ref.watch(rolesLocalProvider).value ?? [];
    final empTypes = ref.watch(employeeTypesLocalProvider).value ?? [];

    final cs = Theme.of(context).colorScheme;

    final state = ref.watch(editEmployeeControllerProvider);

    /// show error dialog when network response error
    ref.listen<AsyncValue>(
      editEmployeeControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminCustomAppBarView(
        title: 'Edit Employee',
        bgColor: Colors.white,
        isShowRightIcon: false,
      ),
      body: Stack(
        children: [
          ///content
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: cs.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, size: 44),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Profile Picture',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: cs.outline),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Full name (required)
                    LabeledInput(
                      label: 'Full Name',
                      controller: _name,
                      validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    /// Phone (required)
                    LabeledInput(
                      label: 'Phone Number',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    /// Country (required)
                    SelectTile(
                      label: 'Country',
                      valueText: labelFor(countries, _countryId),
                      errorText: _countryError,
                      onTap: () async {
                        final v = await pickOne<IDNameVO>(
                          context: context,
                          title: 'Select Country',
                          items: countries,
                          itemBuilder: (e) => Text(e.name ?? ''),
                        );
                        if (v != null) {
                          setState(() {
                            _countryId = v.id;
                            _countryError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Business Unit (required)
                    SelectTile(
                      label: 'Business Unit',
                      valueText: labelFor(businessUnits, _buId),
                      errorText: _buError,
                      onTap: () async {
                        final v = await pickOne<IDNameVO>(
                          context: context,
                          title: 'Select Business Unit',
                          items: businessUnits,
                          itemBuilder: (e) => Text(e.name ?? ''),
                        );
                        if (v != null) {
                          setState(() {
                            _buId = v.id;
                            _buError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Department (required, MULTI-SELECT)
                    SelectTile(
                      label: 'Department',
                      valueText: multiLabelFor(departments, _deptIds),
                      errorText: _deptError,
                      onTap: () async {
                        final selected = await pickMany<IDNameVO>(
                          context: context,
                          title: 'Select Department',
                          items: departments,
                          itemBuilder: (e) => Text(e.name ?? ''),
                          isInitiallySelected: (e) => _deptIds.contains(e.id ?? -1),
                          getId: (e) => e.id,
                        );
                        if (selected != null) {
                          setState(() {
                            _deptIds =
                                selected
                                    .map((e) => e.id ?? 0)
                                    .where((id) => id != 0)
                                    .toList();
                            _deptError = _deptIds.isEmpty ? 'Required' : null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Position (required)
                    SelectTile(
                      label: 'Position',
                      valueText: labelFor(positions, _posId),
                      errorText: _posError,
                      onTap: () async {
                        final v = await pickOne<IDNameVO>(
                          context: context,
                          title: 'Select Position',
                          items: positions,
                          itemBuilder: (e) => Text(e.name ?? ''),
                        );
                        if (v != null) {
                          setState(() {
                            _posId = v.id;
                            _posError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Role (required)
                    SelectTile(
                      label: 'Role',
                      valueText: labelFor(roles, _roleId),
                      errorText: _roleError,
                      onTap: () async {
                        final v = await pickOne<IDNameVO>(
                          context: context,
                          title: 'Select Role',
                          items: roles,
                          itemBuilder: (e) => Text(e.name ?? ''),
                        );
                        if (v != null) {
                          setState(() {
                            _roleId = v.id;
                            _roleError = null;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const SectionLabel(text: 'Login Account'),
                        20.hGap,
                        Expanded(child: Container(color: Colors.grey, height: 1)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// Employee Type (required)
                    SelectTile(
                      label: 'Employee Type',
                      valueText: labelFor(empTypes, _empTypeId),
                      errorText: _empTypeError,
                      onTap: () async {
                        final v = await pickOne<IDNameVO>(
                          context: context,
                          title: 'Select Employee Type',
                          items: empTypes,
                          itemBuilder: (e) => Text(e.name ?? ''),
                        );
                        if (v != null) {
                          setState(() {
                            _empTypeId = v.id;
                            _empTypeError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Email (required + format)
                    LabeledInput(
                      label: 'Email',
                      controller: _email,
                      hint: 'Email',
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Required';
                        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
                        return ok ? null : 'Invalid email';
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Password (optional)
                    LabeledInput(
                      label: 'Password',
                      controller: _password,
                      hint: 'Leave blank to keep current password',
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 6),

                    _switchRow(
                      context: context,
                      title: 'Department Head',
                      value: _isDeptHead,
                      onChanged: (v) => setState(() => _isDeptHead = v),
                    ),
                    _switchRow(
                      context: context,
                      title: 'Allow Remote Login',
                      value: _allowRemote,
                      onChanged: (v) => setState(() => _allowRemote = v),
                    ),
                    _switchRow(
                      context: context,
                      title: 'Active',
                      value: _active,
                      onChanged: (v) => setState(() => _active = v),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: CommonButton(
                        containerVPadding: 10,
                        text: 'Save',
                        onTap: _save,
                        bgColor: kBlueColor,
                        buttonTextColor: Colors.white,
                      ),
                    ),
                  ],
                ),
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
    );
  }

  Widget _switchRow({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: tt.titleSmall)),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: kBlueColor,
            ),
          ),
        ],
      ),
    );
  }
}
