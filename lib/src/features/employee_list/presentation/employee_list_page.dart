import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/employee_list/data/employee_list_repository.dart';
import 'package:hr_app/src/utils/dimens.dart';

import '../model/employee_list_response.dart';
class EmployeeListPage extends ConsumerStatefulWidget {
  const EmployeeListPage({super.key});

  @override
  ConsumerState<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends ConsumerState<EmployeeListPage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  /// pagination state (for non-search)
  final int _pageSize = 10;
  int _pageNo = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _bottomError;

  /// data
  final List<EmployeeVO> _items = <EmployeeVO>[];
  final Set<int> _seenIds = <int>{};

  /// search
  String _query = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _refresh();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_query.isNotEmpty) return; // disable paging when searching
    if (_isLoading || !_hasMore || _bottomError != null) return;
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      _fetchAndAppend();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _pageNo = 1;
      _items.clear();
      _seenIds.clear();
      _hasMore = true;
      _bottomError = null;
    });
    await _fetchAndAppend();
  }

  Future<void> _fetchAndAppend() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _bottomError = null;
    });

    try {
      final resp =
      await ref.read(fetchEmployeeListDataProvider(pageNo: _pageNo).future);

      final List<EmployeeVO> pageList = resp.data?.data ?? <EmployeeVO>[];
      final int? lastPage = resp.data?.lastPage;
      final int? current = resp.data?.current;

      for (final e in pageList) {
        final id = e.id ?? -1;
        if (!_seenIds.contains(id)) {
          _seenIds.add(id);
          _items.add(e);
        }
      }

      setState(() {
        _pageNo += 1;
        if (lastPage != null && current != null) {
          _hasMore = current < lastPage;
        } else {
          _hasMore = pageList.length >= _pageSize;
        }
      });
    } catch (e) {
      setState(() => _bottomError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// ───────────────────────── search handling
  void _onSearchChanged(String t) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      setState(() => _query = t.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSearching = _query.isNotEmpty;

    final searchState = isSearching
        ? ref.watch(searchEmployeeListDataProvider(query: _query))
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminCustomAppBarView(title: 'Employees'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kMarginMedium),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    cursorColor: Colors.black45,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                          if (_items.isEmpty) _refresh();
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 14,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // List
              Expanded(
                child: isSearching
                    ? _SearchResults(searchState: searchState)
                    : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _items.length + 1,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      if (i == _items.length) {
                        if (_bottomError != null) {
                          return _BottomError(
                            message: _bottomError!,
                            onRetry: _fetchAndAppend,
                          );
                        }
                        if (_isLoading) return const _BottomLoader();
                        if (!_hasMore && _items.isNotEmpty) {
                          return const _EndOfList();
                        }
                        return const SizedBox.shrink();
                      }

                      final e = _items[i];
                      return _EmployeeTile(
                        name: e.name ?? '—',
                        role: e.position?.name ?? '—',
                        onTap: () {
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6F9CF3),
        onPressed: () {
          // TODO: add employee
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

/// Search results list (no pagination here)
class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.searchState});
  final AsyncValue<EmployeeListResponse>? searchState;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (searchState == null) return const SizedBox.shrink();

    return searchState!.when(
      data: (resp) {
        final results = resp.data?.data ?? <EmployeeVO>[];
        if (results.isEmpty) {
          return const Center(child: Text('No results'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final e = results[i];
            return _EmployeeTile(
              name: e.name ?? '—',
              role: e.position?.name ?? '—',
              onTap: () {
                // TODO: open detail (e.id)
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString(), style: TextStyle(color: cs.error)),
              const SizedBox(height: 8),
              const Text('Try refining your search'),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({required this.name, required this.role, this.onTap});

  final String name;
  final String role;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _EndOfList extends StatelessWidget {
  const _EndOfList();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text('— End —', style: TextStyle(color: Colors.black54))),
    );
  }
}
