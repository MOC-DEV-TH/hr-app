// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_dashboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newDashboardRepositoryHash() =>
    r'25be0227dfe8cb0fc7f15444ef51be5c73746745';

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
    r'aff40110064c6d90890d67400e65325a0c4df339';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
