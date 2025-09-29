// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDashboardRepositoryHash() =>
    r'3c746f604e526e37b1531facf6d932491fb3fbf1';

/// See also [adminDashboardRepository].
@ProviderFor(adminDashboardRepository)
final adminDashboardRepositoryProvider =
    AutoDisposeProvider<AdminDashboardRepository>.internal(
      adminDashboardRepository,
      name: r'adminDashboardRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$adminDashboardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminDashboardRepositoryRef =
    AutoDisposeProviderRef<AdminDashboardRepository>;
String _$fetchBusinessUnitsHash() =>
    r'329e0861939607f539552a4351b2444fa405bb1d';

/// See also [fetchBusinessUnits].
@ProviderFor(fetchBusinessUnits)
final fetchBusinessUnitsProvider =
    AutoDisposeFutureProvider<BusinessUnitResponse>.internal(
      fetchBusinessUnits,
      name: r'fetchBusinessUnitsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fetchBusinessUnitsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchBusinessUnitsRef =
    AutoDisposeFutureProviderRef<BusinessUnitResponse>;
String _$fetchAdminDashboardDataHash() =>
    r'e13832fa9a3fca8154681f7841b7eb10a7600be6';

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

/// See also [fetchAdminDashboardData].
@ProviderFor(fetchAdminDashboardData)
const fetchAdminDashboardDataProvider = FetchAdminDashboardDataFamily();

/// See also [fetchAdminDashboardData].
class FetchAdminDashboardDataFamily
    extends Family<AsyncValue<AdminDashboardResponse>> {
  /// See also [fetchAdminDashboardData].
  const FetchAdminDashboardDataFamily();

  /// See also [fetchAdminDashboardData].
  FetchAdminDashboardDataProvider call({
    required int businessUnitId,
    required String date,
  }) {
    return FetchAdminDashboardDataProvider(
      businessUnitId: businessUnitId,
      date: date,
    );
  }

  @override
  FetchAdminDashboardDataProvider getProviderOverride(
    covariant FetchAdminDashboardDataProvider provider,
  ) {
    return call(businessUnitId: provider.businessUnitId, date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAdminDashboardDataProvider';
}

/// See also [fetchAdminDashboardData].
class FetchAdminDashboardDataProvider
    extends AutoDisposeFutureProvider<AdminDashboardResponse> {
  /// See also [fetchAdminDashboardData].
  FetchAdminDashboardDataProvider({
    required int businessUnitId,
    required String date,
  }) : this._internal(
         (ref) => fetchAdminDashboardData(
           ref as FetchAdminDashboardDataRef,
           businessUnitId: businessUnitId,
           date: date,
         ),
         from: fetchAdminDashboardDataProvider,
         name: r'fetchAdminDashboardDataProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$fetchAdminDashboardDataHash,
         dependencies: FetchAdminDashboardDataFamily._dependencies,
         allTransitiveDependencies:
             FetchAdminDashboardDataFamily._allTransitiveDependencies,
         businessUnitId: businessUnitId,
         date: date,
       );

  FetchAdminDashboardDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessUnitId,
    required this.date,
  }) : super.internal();

  final int businessUnitId;
  final String date;

  @override
  Override overrideWith(
    FutureOr<AdminDashboardResponse> Function(
      FetchAdminDashboardDataRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAdminDashboardDataProvider._internal(
        (ref) => create(ref as FetchAdminDashboardDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessUnitId: businessUnitId,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AdminDashboardResponse> createElement() {
    return _FetchAdminDashboardDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAdminDashboardDataProvider &&
        other.businessUnitId == businessUnitId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessUnitId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAdminDashboardDataRef
    on AutoDisposeFutureProviderRef<AdminDashboardResponse> {
  /// The parameter `businessUnitId` of this provider.
  int get businessUnitId;

  /// The parameter `date` of this provider.
  String get date;
}

class _FetchAdminDashboardDataProviderElement
    extends AutoDisposeFutureProviderElement<AdminDashboardResponse>
    with FetchAdminDashboardDataRef {
  _FetchAdminDashboardDataProviderElement(super.provider);

  @override
  int get businessUnitId =>
      (origin as FetchAdminDashboardDataProvider).businessUnitId;
  @override
  String get date => (origin as FetchAdminDashboardDataProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
