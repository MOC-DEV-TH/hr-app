// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'29e398f1f8843bc28c6e5def3e007fe733f2ba23';

/// See also [homeRepository].
@ProviderFor(homeRepository)
final homeRepositoryProvider = AutoDisposeProvider<HomeRepository>.internal(
  homeRepository,
  name: r'homeRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRepositoryRef = AutoDisposeProviderRef<HomeRepository>;
String _$fetchAttendanceDataHash() =>
    r'aae4fc2b443bc2f3fcaa2768e8ec734c38f7fbfe';

/// See also [fetchAttendanceData].
@ProviderFor(fetchAttendanceData)
final fetchAttendanceDataProvider =
    AutoDisposeFutureProvider<AttendanceResponse>.internal(
      fetchAttendanceData,
      name: r'fetchAttendanceDataProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fetchAttendanceDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchAttendanceDataRef =
    AutoDisposeFutureProviderRef<AttendanceResponse>;
String _$fetchConfigDataHash() => r'25976a193d86e9d149d20116e900bef54d2f8d8e';

/// See also [fetchConfigData].
@ProviderFor(fetchConfigData)
final fetchConfigDataProvider =
    AutoDisposeFutureProvider<ConfigResponse>.internal(
      fetchConfigData,
      name: r'fetchConfigDataProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fetchConfigDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchConfigDataRef = AutoDisposeFutureProviderRef<ConfigResponse>;
String _$fetchEmployeeDashboardHash() =>
    r'e6e30b9ed07692cddf64222ab8e10599db3ac49b';

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

/// See also [fetchEmployeeDashboard].
@ProviderFor(fetchEmployeeDashboard)
const fetchEmployeeDashboardProvider = FetchEmployeeDashboardFamily();

/// See also [fetchEmployeeDashboard].
class FetchEmployeeDashboardFamily
    extends Family<AsyncValue<EmployeeDashboardResponse>> {
  /// See also [fetchEmployeeDashboard].
  const FetchEmployeeDashboardFamily();

  /// See also [fetchEmployeeDashboard].
  FetchEmployeeDashboardProvider call({required int year, required int month}) {
    return FetchEmployeeDashboardProvider(year: year, month: month);
  }

  @override
  FetchEmployeeDashboardProvider getProviderOverride(
    covariant FetchEmployeeDashboardProvider provider,
  ) {
    return call(year: provider.year, month: provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeeDashboardProvider';
}

/// See also [fetchEmployeeDashboard].
class FetchEmployeeDashboardProvider
    extends AutoDisposeFutureProvider<EmployeeDashboardResponse> {
  /// See also [fetchEmployeeDashboard].
  FetchEmployeeDashboardProvider({required int year, required int month})
    : this._internal(
        (ref) => fetchEmployeeDashboard(
          ref as FetchEmployeeDashboardRef,
          year: year,
          month: month,
        ),
        from: fetchEmployeeDashboardProvider,
        name: r'fetchEmployeeDashboardProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchEmployeeDashboardHash,
        dependencies: FetchEmployeeDashboardFamily._dependencies,
        allTransitiveDependencies:
            FetchEmployeeDashboardFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  FetchEmployeeDashboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<EmployeeDashboardResponse> Function(
      FetchEmployeeDashboardRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeDashboardProvider._internal(
        (ref) => create(ref as FetchEmployeeDashboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EmployeeDashboardResponse> createElement() {
    return _FetchEmployeeDashboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeDashboardProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeDashboardRef
    on AutoDisposeFutureProviderRef<EmployeeDashboardResponse> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _FetchEmployeeDashboardProviderElement
    extends AutoDisposeFutureProviderElement<EmployeeDashboardResponse>
    with FetchEmployeeDashboardRef {
  _FetchEmployeeDashboardProviderElement(super.provider);

  @override
  int get year => (origin as FetchEmployeeDashboardProvider).year;
  @override
  int get month => (origin as FetchEmployeeDashboardProvider).month;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
