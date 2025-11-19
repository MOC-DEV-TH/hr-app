import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/add_new_employee/controller/add_new_employee_controller.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/admin_custom_app_bar_view.dart';
import '../../../common_widgets/common_button.dart';
import '../../../common_widgets/labeled_input.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../common_widgets/section_label.dart';
import '../../../utils/colors.dart';
import '../../../utils/secure_storage.dart';
import '../../admin_dashboard/model/employee_dropdown_response.dart';
import '../../employee_list/data/employee_list_repository.dart';

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

  /// chosen values (now objects)
  IDNameVO? _country;
  IDNameVO? _businessUnit;
  IDNameVO? _position;
  IDNameVO? _role;
  IDNameVO? _employeeType;

  List<IDNameVO> _selectedDepartments = [];
  List<int> _selectedDepartmentIds = [];

  String? _countryError;
  String? _businessUnitError;
  String? _deptError;
  String? _positionError;
  String? _roleError;
  String? _employeeTypeError;

  /// toggles
  bool _isDeptHead = false;
  bool _allowRemote = false;
  bool _active = false;

  /// ui
  bool _obscured = true;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No options available')));
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
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...items.map(
                      (e) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        title: itemBuilder(e),
                        onTap: () => Navigator.of(ctx).pop<T>(e),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Future<List<T>?> _pickMany<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required bool Function(T) isInitiallySelected,
    required Object? Function(T) getId,
  }) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No options available')));
      return Future.value(null);
    }

    final tt = Theme.of(context).textTheme;

    return showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        // local copy of selected ids
        final selectedIds = <Object?>{
          for (final e in items)
            if (isInitiallySelected(e)) getId(e),
        };

        List<T> _currentSelected() =>
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
                            () => Navigator.of(
                              ctx,
                            ).pop<List<T>>(_currentSelected()),
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

  void _save() async {
    /// Validate text fields
    final formOk = _formKey.currentState?.validate() ?? false;

    /// Validate dropdowns
    setState(() {
      _countryError      = _country == null ? 'Required' : null;
      _businessUnitError = _businessUnit == null ? 'Required' : null;
      _deptError         = _selectedDepartmentIds.isEmpty ? 'Required' : null;
      _positionError     = _position == null ? 'Required' : null;
      _roleError         = _role == null ? 'Required' : null;
      _employeeTypeError = _employeeType == null ? 'Required' : null;
    });

    final dropdownOk = [
      _countryError,
      _businessUnitError,
      _deptError,
      _positionError,
      _roleError,
      _employeeTypeError,
    ].every((e) => e == null);

    if (!formOk || !dropdownOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    debugPrint(_selectedDepartmentIds.toString());

    /// Now it's safe to use ! because we just validated
    final payload = {
      'name': _fullNameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'role': _role!.id,
      'country_id': _country!.id,
      'bussiness_unit_id': _businessUnit!.id,
      'department_id':
      _selectedDepartmentIds.isNotEmpty ? _selectedDepartmentIds : [],
      'position_id': _position!.id,
      'employee_type_id': _employeeType!.id,
      'is_department_head': _isDeptHead ? 1 : 0,
      'allow_remote_login': _allowRemote ? 1 : 0,
      'active': _active ? 1 : 0,
    };

    final success = await ref
        .read(addNewEmployeeControllerProvider.notifier)
        .createEmployee(payload);
    if (!mounted) return;

    if (success) {
      ref.invalidate(fetchEmployeeListDataProvider);
      Navigator.pop(context, payload);
    }
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final state = ref.watch(addNewEmployeeControllerProvider);

    /// show error dialog when network response error
    ref.listen<AsyncValue>(
      addNewEmployeeControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    /// watch local dropdown lists from storage
    final countriesAsync = ref.watch(countriesLocalProvider);
    final buAsync = ref.watch(businessUnitsLocalProvider);
    final deptAsync = ref.watch(departmentsLocalProvider);
    final posAsync = ref.watch(positionsLocalProvider);
    final rolesAsync = ref.watch(rolesLocalProvider);
    final empTypesAsync = ref.watch(employeeTypesLocalProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminCustomAppBarView(
        title: 'Add New Employee',
        bgColor: Colors.white,
        isShowRightIcon: false,
      ),
      body: Stack(
        children: [
          /// combine all asyncs: if any is loading, show loader
          countriesAsync.when(
            loading:
                () => const Center(
                  child: LoadingView(
                    indicatorColor: Colors.black,
                    indicator: Indicator.ballRotate,
                  ),
                ),
            error: (e, _) => Center(child: Text('Error loading dropdowns: $e')),
            data: (countries) {
              return buAsync.when(
                loading:
                    () => const Center(
                      child: LoadingView(
                        indicatorColor: Colors.black,
                        indicator: Indicator.ballRotate,
                      ),
                    ),
                error:
                    (e, _) =>
                        Center(child: Text('Error loading dropdowns: $e')),
                data: (businessUnits) {
                  return deptAsync.when(
                    loading:
                        () => const Center(
                          child: LoadingView(
                            indicatorColor: Colors.black,
                            indicator: Indicator.ballRotate,
                          ),
                        ),
                    error:
                        (e, _) =>
                            Center(child: Text('Error loading dropdowns: $e')),
                    data: (departments) {
                      return posAsync.when(
                        loading:
                            () => const Center(
                              child: LoadingView(
                                indicatorColor: Colors.black,
                                indicator: Indicator.ballRotate,
                              ),
                            ),
                        error:
                            (e, _) => Center(
                              child: Text('Error loading dropdowns: $e'),
                            ),
                        data: (positions) {
                          return rolesAsync.when(
                            loading:
                                () => const Center(
                                  child: LoadingView(
                                    indicatorColor: Colors.black,
                                    indicator: Indicator.ballRotate,
                                  ),
                                ),
                            error:
                                (e, _) => Center(
                                  child: Text('Error loading dropdowns: $e'),
                                ),
                            data: (roles) {
                              return empTypesAsync.when(
                                loading:
                                    () => const Center(
                                      child: LoadingView(
                                        indicatorColor: Colors.black,
                                        indicator: Indicator.ballRotate,
                                      ),
                                    ),
                                error:
                                    (e, _) => Center(
                                      child: Text(
                                        'Error loading dropdowns: $e',
                                      ),
                                    ),
                                data: (employeeTypes) {
                                  /// Now we have all lists as List<IDNameVO>
                                  return Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          16,
                                          8,
                                          16,
                                          24,
                                        ),
                                        child: Column(
                                          children: [
                                            /// Profile Picture block ...
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
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                96,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.person,
                                                          size: 44,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 4,
                                                        bottom: 4,
                                                        child: InkWell(
                                                          onTap: () {
                                                            // TODO pick image
                                                          },
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14,
                                                              ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: cs.primary,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    14,
                                                                  ),
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 16,
                                                              color: cs.onPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Profile Picture',
                                                    style: tt.bodySmall?.copyWith(
                                                      color: cs.outline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            /// Full name
                                            LabeledInput(
                                              label: 'Full Name',
                                              controller: _fullNameCtrl,
                                              validator:
                                                  (v) =>
                                              (v?.trim().isEmpty ?? true)
                                                  ? 'Required'
                                                  : null,
                                            ),

                                            const SizedBox(height: 12),

                                            /// Phone number
                                            LabeledInput(
                                              label: 'Phone Number',
                                              controller: _phoneCtrl,
                                              keyboardType: TextInputType.phone,
                                              validator:
                                                  (v) =>
                                              (v?.trim().isEmpty ?? true)
                                                  ? 'Required'
                                                  : null,
                                            ),

                                            const SizedBox(height: 12),

                                            /// Country
                                            LabeledSelect(
                                              label: 'Country',
                                              valueText: _country?.name ?? 'Choose',
                                              onTap: () async {
                                                final v = await _pickOne<IDNameVO>(
                                                  title: 'Select Country',
                                                  items: countries,
                                                  itemBuilder:
                                                      (e) => Text(e.name ?? '-'),
                                                );
                                                if (v != null) {
                                                  setState(() => _country = v);
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Business Unit
                                            LabeledSelect(
                                              label: 'Business Unit',
                                              valueText:
                                                  _businessUnit?.name ?? 'Choose',
                                              onTap: () async {
                                                final v = await _pickOne<IDNameVO>(
                                                  title: 'Select Business Unit',
                                                  items: businessUnits,
                                                  itemBuilder:
                                                      (e) => Text(e.name ?? '-'),
                                                );
                                                if (v != null) {
                                                  setState(() => _businessUnit = v);
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Department
                                            LabeledSelect(
                                              label: 'Department',
                                              valueText:
                                                  _selectedDepartments.isEmpty
                                                      ? 'Choose'
                                                      : _selectedDepartments
                                                          .map((e) => e.name ?? '-')
                                                          .join(', '),
                                              onTap: () async {
                                                final selected =
                                                    await _pickMany<IDNameVO>(
                                                      title: 'Select Department',
                                                      items: departments,
                                                      itemBuilder:
                                                          (e) =>
                                                              Text(e.name ?? '-'),
                                                      // already selected
                                                      isInitiallySelected:
                                                          (e) =>
                                                              _selectedDepartmentIds
                                                                  .contains(e.id),
                                                      getId: (e) => e.id,
                                                    );

                                                if (selected != null) {
                                                  setState(() {
                                                    _selectedDepartments = selected;
                                                    _selectedDepartmentIds =
                                                        selected
                                                            .map((e) => e.id as int)
                                                            .toList();
                                                  });
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Position
                                            LabeledSelect(
                                              label: 'Position',
                                              valueText:
                                                  _position?.name ?? 'Choose',
                                              onTap: () async {
                                                final v = await _pickOne<IDNameVO>(
                                                  title: 'Select Position',
                                                  items: positions,
                                                  itemBuilder:
                                                      (e) => Text(e.name ?? '-'),
                                                );
                                                if (v != null) {
                                                  setState(() => _position = v);
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Role
                                            LabeledSelect(
                                              label: 'Role',
                                              valueText: _role?.name ?? 'Choose',
                                              onTap: () async {
                                                final v = await _pickOne<IDNameVO>(
                                                  title: 'Select Role',
                                                  items: roles,
                                                  itemBuilder:
                                                      (e) => Text(e.name ?? '-'),
                                                );
                                                if (v != null) {
                                                  setState(() => _role = v);
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                const SectionLabel(
                                                  text: 'Login Account',
                                                ),
                                                20.hGap,
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.grey,
                                                    height: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),

                                            /// Employee Type
                                            LabeledSelect(
                                              label: 'Employee Type',
                                              valueText:
                                                  _employeeType?.name ?? 'Choose',
                                              onTap: () async {
                                                final v = await _pickOne<IDNameVO>(
                                                  title: 'Select Employee Type',
                                                  items: employeeTypes,
                                                  itemBuilder:
                                                      (e) => Text(e.name ?? '-'),
                                                );
                                                if (v != null) {
                                                  setState(() => _employeeType = v);
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Email
                                            LabeledInput(
                                              label: 'Email',
                                              controller: _emailCtrl,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (v) {
                                                final s = (v ?? '').trim();
                                                if (s.isEmpty) return 'Required';
                                                final ok = RegExp(
                                                  r'^[^@]+@[^@]+\.[^@]+$',
                                                ).hasMatch(s);
                                                return ok ? null : 'Invalid email';
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Password
                                            LabeledInput(
                                              label: 'Password',
                                              controller: _passwordCtrl,
                                              obscure: _obscured,
                                              validator:
                                                  (v) =>
                                                      (v?.isEmpty ?? true)
                                                          ? 'Required'
                                                          : null,
                                              suffix: IconButton(
                                                icon: Icon(
                                                  _obscured
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                ),
                                                onPressed:
                                                    () => setState(
                                                      () => _obscured = !_obscured,
                                                    ),
                                              ),
                                            ),

                                            const SizedBox(height: 18),

                                            LabeledSwitch(
                                              label: 'Department Head',
                                              value: _isDeptHead,
                                              onChanged:
                                                  (v) => setState(
                                                    () => _isDeptHead = v,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            LabeledSwitch(
                                              label: 'Allow Remote Login',
                                              value: _allowRemote,
                                              onChanged:
                                                  (v) => setState(
                                                    () => _allowRemote = v,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            LabeledSwitch(
                                              label: 'Active',
                                              value: _active,
                                              onChanged:
                                                  (v) =>
                                                      setState(() => _active = v),
                                            ),

                                            const SizedBox(height: 20),
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
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: tt.labelLarge?.copyWith(
                color: cs.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
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
                  Expanded(child: Text(valueText, style: tt.titleMedium)),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
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
            child: Text(
              label,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Transform.scale(
            scale: .85,
            alignment: Alignment.centerRight,
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
