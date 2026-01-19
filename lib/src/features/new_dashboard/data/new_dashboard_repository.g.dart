// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_dashboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newDashboardRepositoryHash() =>
    r'88ae6e92e5037b6bca0190de43ebba53a9bd0a53';

/// See also [newDashboardRepository].
@ProviderFor(newDashboardRepository)
final newDashboardRepositoryProvider =
    AutoDisposeProvider<NewDashboardRepository>.internal(
      newDashboardRepository,
      name: r'newDashboardRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$newDashboardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewDashboardRepositoryRef =
    AutoDisposeProviderRef<NewDashboardRepository>;
String _$fetchDashboardAttendedOverviewHash() =>
    r'54c1a59c4f3d306b5bae29bbee65f31a106e4afe';

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

/// See also [fetchDashboardAttendedOverview].
@ProviderFor(fetchDashboardAttendedOverview)
const fetchDashboardAttendedOverviewProvider =
    FetchDashboardAttendedOverviewFamily();

/// See also [fetchDashboardAttendedOverview].
class FetchDashboardAttendedOverviewFamily
    extends Family<AsyncValue<AttendanceOverviewResponse>> {
  /// See also [fetchDashboardAttendedOverview].
  const FetchDashboardAttendedOverviewFamily();

  /// See also [fetchDashboardAttendedOverview].
  FetchDashboardAttendedOverviewProvider call({String? date}) {
    return FetchDashboardAttendedOverviewProvider(date: date);
  }

  @override
  FetchDashboardAttendedOverviewProvider getProviderOverride(
    covariant FetchDashboardAttendedOverviewProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchDashboardAttendedOverviewProvider';
}

/// See also [fetchDashboardAttendedOverview].
class FetchDashboardAttendedOverviewProvider
    extends AutoDisposeFutureProvider<AttendanceOverviewResponse> {
  /// See also [fetchDashboardAttendedOverview].
  FetchDashboardAttendedOverviewProvider({String? date})
    : this._internal(
        (ref) => fetchDashboardAttendedOverview(
          ref as FetchDashboardAttendedOverviewRef,
          date: date,
        ),
        from: fetchDashboardAttendedOverviewProvider,
        name: r'fetchDashboardAttendedOverviewProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchDashboardAttendedOverviewHash,
        dependencies: FetchDashboardAttendedOverviewFamily._dependencies,
        allTransitiveDependencies:
            FetchDashboardAttendedOverviewFamily._allTransitiveDependencies,
        date: date,
      );

  FetchDashboardAttendedOverviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<AttendanceOverviewResponse> Function(
      FetchDashboardAttendedOverviewRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchDashboardAttendedOverviewProvider._internal(
        (ref) => create(ref as FetchDashboardAttendedOverviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AttendanceOverviewResponse> createElement() {
    return _FetchDashboardAttendedOverviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchDashboardAttendedOverviewProvider &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchDashboardAttendedOverviewRef
    on AutoDisposeFutureProviderRef<AttendanceOverviewResponse> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _FetchDashboardAttendedOverviewProviderElement
    extends AutoDisposeFutureProviderElement<AttendanceOverviewResponse>
    with FetchDashboardAttendedOverviewRef {
  _FetchDashboardAttendedOverviewProviderElement(super.provider);

  @override
  String? get date => (origin as FetchDashboardAttendedOverviewProvider).date;
}

String _$fetchTotalEmployeeDataHash() =>
    r'0512088e8c20bc1ab8b7d0904bbd4ed1a1139ecd';

/// See also [fetchTotalEmployeeData].
@ProviderFor(fetchTotalEmployeeData)
const fetchTotalEmployeeDataProvider = FetchTotalEmployeeDataFamily();

/// See also [fetchTotalEmployeeData].
class FetchTotalEmployeeDataFamily
    extends Family<AsyncValue<TotalEmployeeResponse>> {
  /// See also [fetchTotalEmployeeData].
  const FetchTotalEmployeeDataFamily();

  /// See also [fetchTotalEmployeeData].
  FetchTotalEmployeeDataProvider call({String? date}) {
    return FetchTotalEmployeeDataProvider(date: date);
  }

  @override
  FetchTotalEmployeeDataProvider getProviderOverride(
    covariant FetchTotalEmployeeDataProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchTotalEmployeeDataProvider';
}

/// See also [fetchTotalEmployeeData].
class FetchTotalEmployeeDataProvider
    extends AutoDisposeFutureProvider<TotalEmployeeResponse> {
  /// See also [fetchTotalEmployeeData].
  FetchTotalEmployeeDataProvider({String? date})
    : this._internal(
        (ref) => fetchTotalEmployeeData(
          ref as FetchTotalEmployeeDataRef,
          date: date,
        ),
        from: fetchTotalEmployeeDataProvider,
        name: r'fetchTotalEmployeeDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchTotalEmployeeDataHash,
        dependencies: FetchTotalEmployeeDataFamily._dependencies,
        allTransitiveDependencies:
            FetchTotalEmployeeDataFamily._allTransitiveDependencies,
        date: date,
      );

  FetchTotalEmployeeDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<TotalEmployeeResponse> Function(FetchTotalEmployeeDataRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTotalEmployeeDataProvider._internal(
        (ref) => create(ref as FetchTotalEmployeeDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TotalEmployeeResponse> createElement() {
    return _FetchTotalEmployeeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTotalEmployeeDataProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTotalEmployeeDataRef
    on AutoDisposeFutureProviderRef<TotalEmployeeResponse> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _FetchTotalEmployeeDataProviderElement
    extends AutoDisposeFutureProviderElement<TotalEmployeeResponse>
    with FetchTotalEmployeeDataRef {
  _FetchTotalEmployeeDataProviderElement(super.provider);

  @override
  String? get date => (origin as FetchTotalEmployeeDataProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
