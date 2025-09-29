import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/employees_attendances/data/employees_attendances_repository.dart';

import '../../../common_widgets/employee_row_view.dart';
import '../../../utils/colors.dart';

class EmployeesAttendancePage extends ConsumerStatefulWidget {
  const EmployeesAttendancePage({
    super.key,
    required this.title,
    required this.date,
    required this.businessUintId,
  });

  final String title;
  final int businessUintId;
  final String date;

  @override
  ConsumerState<EmployeesAttendancePage> createState() =>
      _EmployeesAttendancePageState();
}

class _EmployeesAttendancePageState
    extends ConsumerState<EmployeesAttendancePage> {

  static const int _pageSize = 15;
  final _scrollCtrl = ScrollController();
  int _pageNo = 1;
  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;

  final List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _loadFirstPage();
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients || _loadingMore || !_hasMore) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _initialLoading = true;
      _loadingMore = false;
      _hasMore = true;
      _pageNo = 1;
      _items.clear();
      _error = null;
    });
    await _fetchPage(_pageNo);
    if (mounted) {
      setState(() => _initialLoading = false);
    }
  }

  Future<void> _loadNextPage() async {
    if (_loadingMore || !_hasMore) return;
    setState(() {
      _loadingMore = true;
      _error = null;
    });
    await _fetchPage(_pageNo + 1);
    if (mounted) {
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _fetchPage(int page) async {
    try {
      final resp = await ref
          .read(
        fetchEmployeesAttendancesProvider(
          businessUnitId: widget.businessUintId,
          date: widget.date,
          pageNo: page,
        ).future,
      );

      /// Adapt this to your real response structure
      final newItems = resp.data?.data ?? <dynamic>[];

      setState(() {
        _items.addAll(newItems);
        _pageNo = page;
        _hasMore = newItems.length >= _pageSize;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _hasMore = true; 
        });
      }
    }
  }

  Future<void> _retry() async {
    if (_items.isEmpty) {
      await _loadFirstPage();
    } else {
      await _loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AdminCustomAppBarView(title: widget.title),
      body: Column(
        children: [
          const SizedBox(height: 8),

          /// Body
          Expanded(
            child: _initialLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? _EmptyOrErrorView(
              message: _error ?? 'No attendance found.',
              onRetry: _retry,
            )
                : RefreshIndicator(
              onRefresh: _loadFirstPage,
              child: ListView.separated(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(),
                itemBuilder: (_, i) {
                  if (i == _items.length) {
                    if (_loadingMore) {
                      return const _BottomLoader();
                    }
                    if (_error != null) {
                      return _BottomError(
                        message: _error!,
                        onRetry: _loadNextPage,
                      );
                    }
                    if (!_hasMore) {
                      return const _EndOfListLabel();
                    }
                    return const SizedBox.shrink();
                  }
                  return EmployeeRow(employeeAttendanceVO: _items[i]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// bottom widgets

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
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: cs.error)),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
