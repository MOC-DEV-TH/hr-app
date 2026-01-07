import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/utils/extensions.dart';

import '../../../common_widgets/custom_app_bar_view.dart';
import '../../../common_widgets/employee_row_view.dart';
import '../../../utils/colors.dart';
import '../../admin_dashboard/model/admin_dasbhoard_response.dart';
import '../../employee_details/presentation/employee_details_page.dart';
import '../../employees_attendances/data/employees_attendances_repository.dart';

class EmployeesAttendancePage extends ConsumerStatefulWidget {
  const EmployeesAttendancePage({
    super.key,
    required this.title,
    required this.date,
    required this.businessUintId,
  });

  final String title;
  final int businessUintId;
  final DateTime? date;

  @override
  ConsumerState<EmployeesAttendancePage> createState() =>
      _EmployeesAttendancePageState();
}

class _EmployeesAttendancePageState
    extends ConsumerState<EmployeesAttendancePage> {
  static const _pageSize = 15;
  int _pageNo = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _bottomError;

  final List<EmployeeAttendanceDataVO> _entries = [];
  DateTime? _selectedDate;

  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScrollEnd);

  @override
  void initState() {
    super.initState();
    try {
      _selectedDate = widget.date;
    } catch (_) {}
    _loadFirstPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// ──────────────────────────────────── UI ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AdminCustomAppBarView(title: widget.title,isShowRightIcon: false,),
      body: Column(
        children: [
          const SizedBox(height: 6),
          /// Date filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _DateFilterRow(
              dateLabel: _selectedDate == null
                  ? 'Today Attendance'
                  : _selectedDate?.uiLong() ?? '',
              onPickDate: _pickDate,
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading && _entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bottomError != null && _entries.isEmpty) {
      return _EmptyOrErrorView(
        message: _bottomError!,
        onRetry: _loadFirstPage,
      );
    }

    if (_entries.isEmpty) {
      return const _EndOfListLabel();
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      itemCount: _entries.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        if (index < _entries.length) {
          return EmployeeRow(employee: _entries[index],onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => EmployeeDetailsPage(
                  userID:
                  _entries[index].id,
                ),
              ),
            );
          },);
        }

        if (_isLoading) return const _BottomLoader();
        if (_bottomError != null) {
          return _BottomError(
            message: _bottomError!,
            onRetry: _loadNextPage,
          );
        }
        if (!_hasMore) return const _EndOfListLabel();
        return const SizedBox.shrink();
      },
    );
  }


  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select date',
    );
    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
    _loadFirstPage();
  }

  void _onScrollEnd() {
    if (!_hasMore || _isLoading) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  /// ─────────────────────────────── Data load ──────────────────────────────────
  Future<void> _loadFirstPage() async {
    setState(() {
      _entries.clear();
      _pageNo = 1;
      _hasMore = true;
      _bottomError = null;
    });
    await _fetchAndAppend();
  }

  Future<void> _loadNextPage() async {
    if (!_hasMore) return;
    await _fetchAndAppend();
  }

  Future<void> _fetchAndAppend() async {
    setState(() {
      _isLoading = true;
      _bottomError = null;
    });

    try {
      final resp = await ref.read(
        fetchEmployeesAttendancesProvider(
          businessUnitId: widget.businessUintId,
          date: _selectedDate?.ymd() ?? DateTime.now().ymd(),
          pageNo: _pageNo,
        ).future,
      );

      final page = resp.data;
      final List<EmployeeAttendanceDataVO> newItems =
          page?.data ?? const <EmployeeAttendanceDataVO>[];

      setState(() {
        _entries.addAll(newItems);

        if ((page?.current ?? 0) > 0) {
          _pageNo = (page!.current ?? _pageNo) + 1;
        } else {
          _pageNo += 1;
        }

        if ((page?.lastPage ?? 0) > 0 && (page?.current ?? 0) > 0) {
          _hasMore = (page!.current ?? 1) < (page.lastPage ?? 1);
        } else {
          _hasMore = newItems.length >= _pageSize;
        }
      });
    } catch (e) {
      setState(() => _bottomError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// ─────────────────────────────── Date row ─────────────────────────────────────
class _DateFilterRow extends StatelessWidget {
  const _DateFilterRow({
    required this.dateLabel,
    required this.onPickDate,
  });

  final String dateLabel;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            dateLabel,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2D3B4C),
            ),
          ),
        ),
        IconButton(
          onPressed: onPickDate,
          icon: const Icon(Icons.calendar_month_rounded),
          color: cs.outline,
          tooltip: 'Pick date',
        ),
      ],
    );
  }
}

/// ─────────────────────── your bottom widgets (kept) ──────────────────────────
class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _BottomError extends StatelessWidget {
  const _BottomError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Text(message, style: TextStyle(color: cs.error)),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Tap to retry')),
        ],
      ),
    );
  }
}

class _EndOfListLabel extends StatelessWidget {
  const _EndOfListLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class _EmptyOrErrorView extends StatelessWidget {
  const _EmptyOrErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                textAlign: TextAlign.center, style: TextStyle(color: cs.error)),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
