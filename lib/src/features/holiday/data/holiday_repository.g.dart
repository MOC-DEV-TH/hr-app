// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$holidayRepositoryHash() => r'8f76ea9f1e22b89cfd614af385dd00a65fddec7b';

/// See also [holidayRepository].
@ProviderFor(holidayRepository)
final holidayRepositoryProvider =
    AutoDisposeProvider<HolidayRepository>.internal(
      holidayRepository,
      name: r'holidayRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$holidayRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HolidayRepositoryRef = AutoDisposeProviderRef<HolidayRepository>;
String _$fetchHolidaysHash() => r'9a8626d9dbf7fda0bf1473a655642e3d4e1a1a89';

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

/// See also [fetchHolidays].
@ProviderFor(fetchHolidays)
const fetchHolidaysProvider = FetchHolidaysFamily();

/// See also [fetchHolidays].
class FetchHolidaysFamily extends Family<AsyncValue<HolidayResponse>> {
  /// See also [fetchHolidays].
  const FetchHolidaysFamily();

  /// See also [fetchHolidays].
  FetchHolidaysProvider call({int? businessUnitId}) {
    return FetchHolidaysProvider(businessUnitId: businessUnitId);
  }

  @override
  FetchHolidaysProvider getProviderOverride(
    covariant FetchHolidaysProvider provider,
  ) {
    return call(businessUnitId: provider.businessUnitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchHolidaysProvider';
}

/// See also [fetchHolidays].
class FetchHolidaysProvider extends AutoDisposeFutureProvider<HolidayResponse> {
  /// See also [fetchHolidays].
  FetchHolidaysProvider({int? businessUnitId})
    : this._internal(
        (ref) => fetchHolidays(
          ref as FetchHolidaysRef,
          businessUnitId: businessUnitId,
        ),
        from: fetchHolidaysProvider,
        name: r'fetchHolidaysProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchHolidaysHash,
        dependencies: FetchHolidaysFamily._dependencies,
        allTransitiveDependencies:
            FetchHolidaysFamily._allTransitiveDependencies,
        businessUnitId: businessUnitId,
      );

  FetchHolidaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessUnitId,
  }) : super.internal();

  final int? businessUnitId;

  @override
  Override overrideWith(
    FutureOr<HolidayResponse> Function(FetchHolidaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchHolidaysProvider._internal(
        (ref) => create(ref as FetchHolidaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessUnitId: businessUnitId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HolidayResponse> createElement() {
    return _FetchHolidaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchHolidaysProvider &&
        other.businessUnitId == businessUnitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessUnitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchHolidaysRef on AutoDisposeFutureProviderRef<HolidayResponse> {
  /// The parameter `businessUnitId` of this provider.
  int? get businessUnitId;
}

class _FetchHolidaysProviderElement
    extends AutoDisposeFutureProviderElement<HolidayResponse>
    with FetchHolidaysRef {
  _FetchHolidaysProviderElement(super.provider);

  @override
  int? get businessUnitId => (origin as FetchHolidaysProvider).businessUnitId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
