// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_list_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeListRepositoryHash() =>
    r'a6b7c86d4fea94bda8459d37c5007b20882d5858';

/// See also [employeeListRepository].
@ProviderFor(employeeListRepository)
final employeeListRepositoryProvider =
    AutoDisposeProvider<EmployeeListRepository>.internal(
      employeeListRepository,
      name: r'employeeListRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeListRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeListRepositoryRef =
    AutoDisposeProviderRef<EmployeeListRepository>;
String _$fetchEmployeeListDataHash() =>
    r'a35c7953b7e077270eb91cd06fa4c27066155a34';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchEmployeeListData].
@ProviderFor(fetchEmployeeListData)
const fetchEmployeeListDataProvider = FetchEmployeeListDataFamily();

/// See also [fetchEmployeeListData].
class FetchEmployeeListDataFamily
    extends Family<AsyncValue<EmployeeListResponse>> {
  /// See also [fetchEmployeeListData].
  const FetchEmployeeListDataFamily();

  /// See also [fetchEmployeeListData].
  FetchEmployeeListDataProvider call({required int pageNo}) {
    return FetchEmployeeListDataProvider(pageNo: pageNo);
  }

  @override
  FetchEmployeeListDataProvider getProviderOverride(
    covariant FetchEmployeeListDataProvider provider,
  ) {
    return call(pageNo: provider.pageNo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeeListDataProvider';
}

/// See also [fetchEmployeeListData].
class FetchEmployeeListDataProvider
    extends AutoDisposeFutureProvider<EmployeeListResponse> {
  /// See also [fetchEmployeeListData].
  FetchEmployeeListDataProvider({required int pageNo})
    : this._internal(
        (ref) => fetchEmployeeListData(
          ref as FetchEmployeeListDataRef,
          pageNo: pageNo,
        ),
        from: fetchEmployeeListDataProvider,
        name: r'fetchEmployeeListDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchEmployeeListDataHash,
        dependencies: FetchEmployeeListDataFamily._dependencies,
        allTransitiveDependencies:
            FetchEmployeeListDataFamily._allTransitiveDependencies,
        pageNo: pageNo,
      );

  FetchEmployeeListDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
  }) : super.internal();

  final int pageNo;

  @override
  Override overrideWith(
    FutureOr<EmployeeListResponse> Function(FetchEmployeeListDataRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeListDataProvider._internal(
        (ref) => create(ref as FetchEmployeeListDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EmployeeListResponse> createElement() {
    return _FetchEmployeeListDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeListDataProvider && other.pageNo == pageNo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeListDataRef
    on AutoDisposeFutureProviderRef<EmployeeListResponse> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;
}

class _FetchEmployeeListDataProviderElement
    extends AutoDisposeFutureProviderElement<EmployeeListResponse>
    with FetchEmployeeListDataRef {
  _FetchEmployeeListDataProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchEmployeeListDataProvider).pageNo;
}

String _$searchEmployeeListDataHash() =>
    r'a0f9dfdf27a401f3747cbde14cd7142a8a006e18';

/// See also [searchEmployeeListData].
@ProviderFor(searchEmployeeListData)
const searchEmployeeListDataProvider = SearchEmployeeListDataFamily();

/// See also [searchEmployeeListData].
class SearchEmployeeListDataFamily
    extends Family<AsyncValue<EmployeeListResponse>> {
  /// See also [searchEmployeeListData].
  const SearchEmployeeListDataFamily();

  /// See also [searchEmployeeListData].
  SearchEmployeeListDataProvider call({required String query}) {
    return SearchEmployeeListDataProvider(query: query);
  }

  @override
  SearchEmployeeListDataProvider getProviderOverride(
    covariant SearchEmployeeListDataProvider provider,
  ) {
    return call(query: provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchEmployeeListDataProvider';
}

/// See also [searchEmployeeListData].
class SearchEmployeeListDataProvider
    extends AutoDisposeFutureProvider<EmployeeListResponse> {
  /// See also [searchEmployeeListData].
  SearchEmployeeListDataProvider({required String query})
    : this._internal(
        (ref) => searchEmployeeListData(
          ref as SearchEmployeeListDataRef,
          query: query,
        ),
        from: searchEmployeeListDataProvider,
        name: r'searchEmployeeListDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchEmployeeListDataHash,
        dependencies: SearchEmployeeListDataFamily._dependencies,
        allTransitiveDependencies:
            SearchEmployeeListDataFamily._allTransitiveDependencies,
        query: query,
      );

  SearchEmployeeListDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<EmployeeListResponse> Function(SearchEmployeeListDataRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchEmployeeListDataProvider._internal(
        (ref) => create(ref as SearchEmployeeListDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EmployeeListResponse> createElement() {
    return _SearchEmployeeListDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchEmployeeListDataProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchEmployeeListDataRef
    on AutoDisposeFutureProviderRef<EmployeeListResponse> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchEmployeeListDataProviderElement
    extends AutoDisposeFutureProviderElement<EmployeeListResponse>
    with SearchEmployeeListDataRef {
  _SearchEmployeeListDataProviderElement(super.provider);

  @override
  String get query => (origin as SearchEmployeeListDataProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
