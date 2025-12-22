// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_wfh_requests_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeesWfhRequestsRepositoryHash() =>
    r'9f2518bf3e8a15367f735774bdb2723f2a812263';

/// See also [employeesWfhRequestsRepository].
@ProviderFor(employeesWfhRequestsRepository)
final employeesWfhRequestsRepositoryProvider =
    AutoDisposeProvider<EmployeesWfhRequestsRepository>.internal(
      employeesWfhRequestsRepository,
      name: r'employeesWfhRequestsRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeesWfhRequestsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeesWfhRequestsRepositoryRef =
    AutoDisposeProviderRef<EmployeesWfhRequestsRepository>;
String _$fetchAllEmployeesWfhRequestHash() =>
    r'75d54a72e222a877d02a0f5fbf213c8035f2d48d';

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

/// See also [fetchAllEmployeesWfhRequest].
@ProviderFor(fetchAllEmployeesWfhRequest)
const fetchAllEmployeesWfhRequestProvider = FetchAllEmployeesWfhRequestFamily();

/// See also [fetchAllEmployeesWfhRequest].
class FetchAllEmployeesWfhRequestFamily
    extends Family<AsyncValue<WfhRequestsResponse>> {
  /// See also [fetchAllEmployeesWfhRequest].
  const FetchAllEmployeesWfhRequestFamily();

  /// See also [fetchAllEmployeesWfhRequest].
  FetchAllEmployeesWfhRequestProvider call({
    String? date,
    String? leaveStatus,
  }) {
    return FetchAllEmployeesWfhRequestProvider(
      date: date,
      leaveStatus: leaveStatus,
    );
  }

  @override
  FetchAllEmployeesWfhRequestProvider getProviderOverride(
    covariant FetchAllEmployeesWfhRequestProvider provider,
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
  String? get name => r'fetchAllEmployeesWfhRequestProvider';
}

/// See also [fetchAllEmployeesWfhRequest].
class FetchAllEmployeesWfhRequestProvider
    extends AutoDisposeFutureProvider<WfhRequestsResponse> {
  /// See also [fetchAllEmployeesWfhRequest].
  FetchAllEmployeesWfhRequestProvider({String? date, String? leaveStatus})
    : this._internal(
        (ref) => fetchAllEmployeesWfhRequest(
          ref as FetchAllEmployeesWfhRequestRef,
          date: date,
          leaveStatus: leaveStatus,
        ),
        from: fetchAllEmployeesWfhRequestProvider,
        name: r'fetchAllEmployeesWfhRequestProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchAllEmployeesWfhRequestHash,
        dependencies: FetchAllEmployeesWfhRequestFamily._dependencies,
        allTransitiveDependencies:
            FetchAllEmployeesWfhRequestFamily._allTransitiveDependencies,
        date: date,
        leaveStatus: leaveStatus,
      );

  FetchAllEmployeesWfhRequestProvider._internal(
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
    FutureOr<WfhRequestsResponse> Function(
      FetchAllEmployeesWfhRequestRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAllEmployeesWfhRequestProvider._internal(
        (ref) => create(ref as FetchAllEmployeesWfhRequestRef),
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
  AutoDisposeFutureProviderElement<WfhRequestsResponse> createElement() {
    return _FetchAllEmployeesWfhRequestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllEmployeesWfhRequestProvider &&
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
mixin FetchAllEmployeesWfhRequestRef
    on AutoDisposeFutureProviderRef<WfhRequestsResponse> {
  /// The parameter `date` of this provider.
  String? get date;

  /// The parameter `leaveStatus` of this provider.
  String? get leaveStatus;
}

class _FetchAllEmployeesWfhRequestProviderElement
    extends AutoDisposeFutureProviderElement<WfhRequestsResponse>
    with FetchAllEmployeesWfhRequestRef {
  _FetchAllEmployeesWfhRequestProviderElement(super.provider);

  @override
  String? get date => (origin as FetchAllEmployeesWfhRequestProvider).date;
  @override
  String? get leaveStatus =>
      (origin as FetchAllEmployeesWfhRequestProvider).leaveStatus;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
