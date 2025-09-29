// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_attendances_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeesAttendancesRepositoryHash() =>
    r'361f1dbac49c3ea24f5f2db252e1b106fa212695';

/// See also [employeesAttendancesRepository].
@ProviderFor(employeesAttendancesRepository)
final employeesAttendancesRepositoryProvider =
    AutoDisposeProvider<EmployeesAttendancesRepository>.internal(
      employeesAttendancesRepository,
      name: r'employeesAttendancesRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeesAttendancesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeesAttendancesRepositoryRef =
    AutoDisposeProviderRef<EmployeesAttendancesRepository>;
String _$fetchEmployeesAttendancesHash() =>
    r'b87e58658d349271b0855a65b85eec83d0e79821';

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

/// See also [fetchEmployeesAttendances].
@ProviderFor(fetchEmployeesAttendances)
const fetchEmployeesAttendancesProvider = FetchEmployeesAttendancesFamily();

/// See also [fetchEmployeesAttendances].
class FetchEmployeesAttendancesFamily
    extends Family<AsyncValue<EmployeesAttendancesResponse>> {
  /// See also [fetchEmployeesAttendances].
  const FetchEmployeesAttendancesFamily();

  /// See also [fetchEmployeesAttendances].
  FetchEmployeesAttendancesProvider call({
    required int businessUnitId,
    required String date,
    required int pageNo,
  }) {
    return FetchEmployeesAttendancesProvider(
      businessUnitId: businessUnitId,
      date: date,
      pageNo: pageNo,
    );
  }

  @override
  FetchEmployeesAttendancesProvider getProviderOverride(
    covariant FetchEmployeesAttendancesProvider provider,
  ) {
    return call(
      businessUnitId: provider.businessUnitId,
      date: provider.date,
      pageNo: provider.pageNo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeesAttendancesProvider';
}

/// See also [fetchEmployeesAttendances].
class FetchEmployeesAttendancesProvider
    extends AutoDisposeFutureProvider<EmployeesAttendancesResponse> {
  /// See also [fetchEmployeesAttendances].
  FetchEmployeesAttendancesProvider({
    required int businessUnitId,
    required String date,
    required int pageNo,
  }) : this._internal(
         (ref) => fetchEmployeesAttendances(
           ref as FetchEmployeesAttendancesRef,
           businessUnitId: businessUnitId,
           date: date,
           pageNo: pageNo,
         ),
         from: fetchEmployeesAttendancesProvider,
         name: r'fetchEmployeesAttendancesProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$fetchEmployeesAttendancesHash,
         dependencies: FetchEmployeesAttendancesFamily._dependencies,
         allTransitiveDependencies:
             FetchEmployeesAttendancesFamily._allTransitiveDependencies,
         businessUnitId: businessUnitId,
         date: date,
         pageNo: pageNo,
       );

  FetchEmployeesAttendancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessUnitId,
    required this.date,
    required this.pageNo,
  }) : super.internal();

  final int businessUnitId;
  final String date;
  final int pageNo;

  @override
  Override overrideWith(
    FutureOr<EmployeesAttendancesResponse> Function(
      FetchEmployeesAttendancesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeesAttendancesProvider._internal(
        (ref) => create(ref as FetchEmployeesAttendancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessUnitId: businessUnitId,
        date: date,
        pageNo: pageNo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EmployeesAttendancesResponse>
  createElement() {
    return _FetchEmployeesAttendancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeesAttendancesProvider &&
        other.businessUnitId == businessUnitId &&
        other.date == date &&
        other.pageNo == pageNo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessUnitId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeesAttendancesRef
    on AutoDisposeFutureProviderRef<EmployeesAttendancesResponse> {
  /// The parameter `businessUnitId` of this provider.
  int get businessUnitId;

  /// The parameter `date` of this provider.
  String get date;

  /// The parameter `pageNo` of this provider.
  int get pageNo;
}

class _FetchEmployeesAttendancesProviderElement
    extends AutoDisposeFutureProviderElement<EmployeesAttendancesResponse>
    with FetchEmployeesAttendancesRef {
  _FetchEmployeesAttendancesProviderElement(super.provider);

  @override
  int get businessUnitId =>
      (origin as FetchEmployeesAttendancesProvider).businessUnitId;
  @override
  String get date => (origin as FetchEmployeesAttendancesProvider).date;
  @override
  int get pageNo => (origin as FetchEmployeesAttendancesProvider).pageNo;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
