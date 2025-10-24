// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_leaves_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeLeavesRepositoryHash() =>
    r'6374c22f7144089038c3aa4b852d3c943583f37f';

/// See also [employeeLeavesRepository].
@ProviderFor(employeeLeavesRepository)
final employeeLeavesRepositoryProvider =
    AutoDisposeProvider<EmployeeLeavesRepository>.internal(
      employeeLeavesRepository,
      name: r'employeeLeavesRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeLeavesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeLeavesRepositoryRef =
    AutoDisposeProviderRef<EmployeeLeavesRepository>;
String _$fetchAllEmployeeLeavesHash() =>
    r'e882cfea198cd8e01be5228368c192a16af04a50';

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

/// See also [fetchAllEmployeeLeaves].
@ProviderFor(fetchAllEmployeeLeaves)
const fetchAllEmployeeLeavesProvider = FetchAllEmployeeLeavesFamily();

/// See also [fetchAllEmployeeLeaves].
class FetchAllEmployeeLeavesFamily
    extends Family<AsyncValue<LeaveStatusResponse>> {
  /// See also [fetchAllEmployeeLeaves].
  const FetchAllEmployeeLeavesFamily();

  /// See also [fetchAllEmployeeLeaves].
  FetchAllEmployeeLeavesProvider call({String? date, String? leaveStatus}) {
    return FetchAllEmployeeLeavesProvider(date: date, leaveStatus: leaveStatus);
  }

  @override
  FetchAllEmployeeLeavesProvider getProviderOverride(
    covariant FetchAllEmployeeLeavesProvider provider,
  ) {
    return call(date: provider.date, leaveStatus: provider.leaveStatus);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAllEmployeeLeavesProvider';
}

/// See also [fetchAllEmployeeLeaves].
class FetchAllEmployeeLeavesProvider
    extends AutoDisposeFutureProvider<LeaveStatusResponse> {
  /// See also [fetchAllEmployeeLeaves].
  FetchAllEmployeeLeavesProvider({String? date, String? leaveStatus})
    : this._internal(
        (ref) => fetchAllEmployeeLeaves(
          ref as FetchAllEmployeeLeavesRef,
          date: date,
          leaveStatus: leaveStatus,
        ),
        from: fetchAllEmployeeLeavesProvider,
        name: r'fetchAllEmployeeLeavesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchAllEmployeeLeavesHash,
        dependencies: FetchAllEmployeeLeavesFamily._dependencies,
        allTransitiveDependencies:
            FetchAllEmployeeLeavesFamily._allTransitiveDependencies,
        date: date,
        leaveStatus: leaveStatus,
      );

  FetchAllEmployeeLeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
    required this.leaveStatus,
  }) : super.internal();

  final String? date;
  final String? leaveStatus;

  @override
  Override overrideWith(
    FutureOr<LeaveStatusResponse> Function(FetchAllEmployeeLeavesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAllEmployeeLeavesProvider._internal(
        (ref) => create(ref as FetchAllEmployeeLeavesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
        leaveStatus: leaveStatus,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LeaveStatusResponse> createElement() {
    return _FetchAllEmployeeLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllEmployeeLeavesProvider &&
        other.date == date &&
        other.leaveStatus == leaveStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, leaveStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAllEmployeeLeavesRef
    on AutoDisposeFutureProviderRef<LeaveStatusResponse> {
  /// The parameter `date` of this provider.
  String? get date;

  /// The parameter `leaveStatus` of this provider.
  String? get leaveStatus;
}

class _FetchAllEmployeeLeavesProviderElement
    extends AutoDisposeFutureProviderElement<LeaveStatusResponse>
    with FetchAllEmployeeLeavesRef {
  _FetchAllEmployeeLeavesProviderElement(super.provider);

  @override
  String? get date => (origin as FetchAllEmployeeLeavesProvider).date;
  @override
  String? get leaveStatus =>
      (origin as FetchAllEmployeeLeavesProvider).leaveStatus;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
