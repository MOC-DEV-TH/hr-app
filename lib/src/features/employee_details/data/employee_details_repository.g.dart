// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_details_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeDetailsRepositoryHash() =>
    r'bded034d0ef722c69808b81f971a38dc4413e66c';

/// See also [employeeDetailsRepository].
@ProviderFor(employeeDetailsRepository)
final employeeDetailsRepositoryProvider =
    AutoDisposeProvider<EmployeeDetailsRepository>.internal(
      employeeDetailsRepository,
      name: r'employeeDetailsRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$employeeDetailsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeDetailsRepositoryRef =
    AutoDisposeProviderRef<EmployeeDetailsRepository>;
String _$fetchEmployeeProfileDataHash() =>
    r'2a00c86c98827906ae9a07de25807e4da25f17ce';

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

/// See also [fetchEmployeeProfileData].
@ProviderFor(fetchEmployeeProfileData)
const fetchEmployeeProfileDataProvider = FetchEmployeeProfileDataFamily();

/// See also [fetchEmployeeProfileData].
class FetchEmployeeProfileDataFamily
    extends Family<AsyncValue<EmployeeProfileResponse>> {
  /// See also [fetchEmployeeProfileData].
  const FetchEmployeeProfileDataFamily();

  /// See also [fetchEmployeeProfileData].
  FetchEmployeeProfileDataProvider call({required int userID}) {
    return FetchEmployeeProfileDataProvider(userID: userID);
  }

  @override
  FetchEmployeeProfileDataProvider getProviderOverride(
    covariant FetchEmployeeProfileDataProvider provider,
  ) {
    return call(userID: provider.userID);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeeProfileDataProvider';
}

/// See also [fetchEmployeeProfileData].
class FetchEmployeeProfileDataProvider
    extends AutoDisposeFutureProvider<EmployeeProfileResponse> {
  /// See also [fetchEmployeeProfileData].
  FetchEmployeeProfileDataProvider({required int userID})
    : this._internal(
        (ref) => fetchEmployeeProfileData(
          ref as FetchEmployeeProfileDataRef,
          userID: userID,
        ),
        from: fetchEmployeeProfileDataProvider,
        name: r'fetchEmployeeProfileDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchEmployeeProfileDataHash,
        dependencies: FetchEmployeeProfileDataFamily._dependencies,
        allTransitiveDependencies:
            FetchEmployeeProfileDataFamily._allTransitiveDependencies,
        userID: userID,
      );

  FetchEmployeeProfileDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
  }) : super.internal();

  final int userID;

  @override
  Override overrideWith(
    FutureOr<EmployeeProfileResponse> Function(
      FetchEmployeeProfileDataRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeProfileDataProvider._internal(
        (ref) => create(ref as FetchEmployeeProfileDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EmployeeProfileResponse> createElement() {
    return _FetchEmployeeProfileDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeProfileDataProvider && other.userID == userID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeProfileDataRef
    on AutoDisposeFutureProviderRef<EmployeeProfileResponse> {
  /// The parameter `userID` of this provider.
  int get userID;
}

class _FetchEmployeeProfileDataProviderElement
    extends AutoDisposeFutureProviderElement<EmployeeProfileResponse>
    with FetchEmployeeProfileDataRef {
  _FetchEmployeeProfileDataProviderElement(super.provider);

  @override
  int get userID => (origin as FetchEmployeeProfileDataProvider).userID;
}

String _$fetchEmployeeLeavesDataHash() =>
    r'89cdd6cc9f91da62f33f66ffa01173dcb09bdef7';

/// See also [fetchEmployeeLeavesData].
@ProviderFor(fetchEmployeeLeavesData)
const fetchEmployeeLeavesDataProvider = FetchEmployeeLeavesDataFamily();

/// See also [fetchEmployeeLeavesData].
class FetchEmployeeLeavesDataFamily
    extends Family<AsyncValue<LeaveStatusResponse>> {
  /// See also [fetchEmployeeLeavesData].
  const FetchEmployeeLeavesDataFamily();

  /// See also [fetchEmployeeLeavesData].
  FetchEmployeeLeavesDataProvider call({
    required int userID,
    required String leaveStatus,
  }) {
    return FetchEmployeeLeavesDataProvider(
      userID: userID,
      leaveStatus: leaveStatus,
    );
  }

  @override
  FetchEmployeeLeavesDataProvider getProviderOverride(
    covariant FetchEmployeeLeavesDataProvider provider,
  ) {
    return call(userID: provider.userID, leaveStatus: provider.leaveStatus);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeeLeavesDataProvider';
}

/// See also [fetchEmployeeLeavesData].
class FetchEmployeeLeavesDataProvider
    extends AutoDisposeFutureProvider<LeaveStatusResponse> {
  /// See also [fetchEmployeeLeavesData].
  FetchEmployeeLeavesDataProvider({
    required int userID,
    required String leaveStatus,
  }) : this._internal(
         (ref) => fetchEmployeeLeavesData(
           ref as FetchEmployeeLeavesDataRef,
           userID: userID,
           leaveStatus: leaveStatus,
         ),
         from: fetchEmployeeLeavesDataProvider,
         name: r'fetchEmployeeLeavesDataProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$fetchEmployeeLeavesDataHash,
         dependencies: FetchEmployeeLeavesDataFamily._dependencies,
         allTransitiveDependencies:
             FetchEmployeeLeavesDataFamily._allTransitiveDependencies,
         userID: userID,
         leaveStatus: leaveStatus,
       );

  FetchEmployeeLeavesDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
    required this.leaveStatus,
  }) : super.internal();

  final int userID;
  final String leaveStatus;

  @override
  Override overrideWith(
    FutureOr<LeaveStatusResponse> Function(FetchEmployeeLeavesDataRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeLeavesDataProvider._internal(
        (ref) => create(ref as FetchEmployeeLeavesDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
        leaveStatus: leaveStatus,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LeaveStatusResponse> createElement() {
    return _FetchEmployeeLeavesDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeLeavesDataProvider &&
        other.userID == userID &&
        other.leaveStatus == leaveStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);
    hash = _SystemHash.combine(hash, leaveStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeLeavesDataRef
    on AutoDisposeFutureProviderRef<LeaveStatusResponse> {
  /// The parameter `userID` of this provider.
  int get userID;

  /// The parameter `leaveStatus` of this provider.
  String get leaveStatus;
}

class _FetchEmployeeLeavesDataProviderElement
    extends AutoDisposeFutureProviderElement<LeaveStatusResponse>
    with FetchEmployeeLeavesDataRef {
  _FetchEmployeeLeavesDataProviderElement(super.provider);

  @override
  int get userID => (origin as FetchEmployeeLeavesDataProvider).userID;
  @override
  String get leaveStatus =>
      (origin as FetchEmployeeLeavesDataProvider).leaveStatus;
}

String _$fetchEmployeeAttendancesDataHash() =>
    r'f5a5e3add7d799af6b4e026c6f2a90c98b198f97';

/// See also [fetchEmployeeAttendancesData].
@ProviderFor(fetchEmployeeAttendancesData)
const fetchEmployeeAttendancesDataProvider =
    FetchEmployeeAttendancesDataFamily();

/// See also [fetchEmployeeAttendancesData].
class FetchEmployeeAttendancesDataFamily
    extends Family<AsyncValue<AttendanceResponse>> {
  /// See also [fetchEmployeeAttendancesData].
  const FetchEmployeeAttendancesDataFamily();

  /// See also [fetchEmployeeAttendancesData].
  FetchEmployeeAttendancesDataProvider call({
    required int userID,
    required String year,
    required String month,
  }) {
    return FetchEmployeeAttendancesDataProvider(
      userID: userID,
      year: year,
      month: month,
    );
  }

  @override
  FetchEmployeeAttendancesDataProvider getProviderOverride(
    covariant FetchEmployeeAttendancesDataProvider provider,
  ) {
    return call(
      userID: provider.userID,
      year: provider.year,
      month: provider.month,
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
  String? get name => r'fetchEmployeeAttendancesDataProvider';
}

/// See also [fetchEmployeeAttendancesData].
class FetchEmployeeAttendancesDataProvider
    extends AutoDisposeFutureProvider<AttendanceResponse> {
  /// See also [fetchEmployeeAttendancesData].
  FetchEmployeeAttendancesDataProvider({
    required int userID,
    required String year,
    required String month,
  }) : this._internal(
         (ref) => fetchEmployeeAttendancesData(
           ref as FetchEmployeeAttendancesDataRef,
           userID: userID,
           year: year,
           month: month,
         ),
         from: fetchEmployeeAttendancesDataProvider,
         name: r'fetchEmployeeAttendancesDataProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$fetchEmployeeAttendancesDataHash,
         dependencies: FetchEmployeeAttendancesDataFamily._dependencies,
         allTransitiveDependencies:
             FetchEmployeeAttendancesDataFamily._allTransitiveDependencies,
         userID: userID,
         year: year,
         month: month,
       );

  FetchEmployeeAttendancesDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
    required this.year,
    required this.month,
  }) : super.internal();

  final int userID;
  final String year;
  final String month;

  @override
  Override overrideWith(
    FutureOr<AttendanceResponse> Function(
      FetchEmployeeAttendancesDataRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeAttendancesDataProvider._internal(
        (ref) => create(ref as FetchEmployeeAttendancesDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AttendanceResponse> createElement() {
    return _FetchEmployeeAttendancesDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeAttendancesDataProvider &&
        other.userID == userID &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeAttendancesDataRef
    on AutoDisposeFutureProviderRef<AttendanceResponse> {
  /// The parameter `userID` of this provider.
  int get userID;

  /// The parameter `year` of this provider.
  String get year;

  /// The parameter `month` of this provider.
  String get month;
}

class _FetchEmployeeAttendancesDataProviderElement
    extends AutoDisposeFutureProviderElement<AttendanceResponse>
    with FetchEmployeeAttendancesDataRef {
  _FetchEmployeeAttendancesDataProviderElement(super.provider);

  @override
  int get userID => (origin as FetchEmployeeAttendancesDataProvider).userID;
  @override
  String get year => (origin as FetchEmployeeAttendancesDataProvider).year;
  @override
  String get month => (origin as FetchEmployeeAttendancesDataProvider).month;
}

String _$fetchEmployeeLeaveSummaryDataHash() =>
    r'b9a7822c12071e680fb988e58ed2abaa8798e027';

/// See also [fetchEmployeeLeaveSummaryData].
@ProviderFor(fetchEmployeeLeaveSummaryData)
const fetchEmployeeLeaveSummaryDataProvider =
    FetchEmployeeLeaveSummaryDataFamily();

/// See also [fetchEmployeeLeaveSummaryData].
class FetchEmployeeLeaveSummaryDataFamily
    extends Family<AsyncValue<LeaveSummaryResponse>> {
  /// See also [fetchEmployeeLeaveSummaryData].
  const FetchEmployeeLeaveSummaryDataFamily();

  /// See also [fetchEmployeeLeaveSummaryData].
  FetchEmployeeLeaveSummaryDataProvider call({required int userID}) {
    return FetchEmployeeLeaveSummaryDataProvider(userID: userID);
  }

  @override
  FetchEmployeeLeaveSummaryDataProvider getProviderOverride(
    covariant FetchEmployeeLeaveSummaryDataProvider provider,
  ) {
    return call(userID: provider.userID);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmployeeLeaveSummaryDataProvider';
}

/// See also [fetchEmployeeLeaveSummaryData].
class FetchEmployeeLeaveSummaryDataProvider
    extends AutoDisposeFutureProvider<LeaveSummaryResponse> {
  /// See also [fetchEmployeeLeaveSummaryData].
  FetchEmployeeLeaveSummaryDataProvider({required int userID})
    : this._internal(
        (ref) => fetchEmployeeLeaveSummaryData(
          ref as FetchEmployeeLeaveSummaryDataRef,
          userID: userID,
        ),
        from: fetchEmployeeLeaveSummaryDataProvider,
        name: r'fetchEmployeeLeaveSummaryDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchEmployeeLeaveSummaryDataHash,
        dependencies: FetchEmployeeLeaveSummaryDataFamily._dependencies,
        allTransitiveDependencies:
            FetchEmployeeLeaveSummaryDataFamily._allTransitiveDependencies,
        userID: userID,
      );

  FetchEmployeeLeaveSummaryDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
  }) : super.internal();

  final int userID;

  @override
  Override overrideWith(
    FutureOr<LeaveSummaryResponse> Function(
      FetchEmployeeLeaveSummaryDataRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmployeeLeaveSummaryDataProvider._internal(
        (ref) => create(ref as FetchEmployeeLeaveSummaryDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LeaveSummaryResponse> createElement() {
    return _FetchEmployeeLeaveSummaryDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmployeeLeaveSummaryDataProvider &&
        other.userID == userID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEmployeeLeaveSummaryDataRef
    on AutoDisposeFutureProviderRef<LeaveSummaryResponse> {
  /// The parameter `userID` of this provider.
  int get userID;
}

class _FetchEmployeeLeaveSummaryDataProviderElement
    extends AutoDisposeFutureProviderElement<LeaveSummaryResponse>
    with FetchEmployeeLeaveSummaryDataRef {
  _FetchEmployeeLeaveSummaryDataProviderElement(super.provider);

  @override
  int get userID => (origin as FetchEmployeeLeaveSummaryDataProvider).userID;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
