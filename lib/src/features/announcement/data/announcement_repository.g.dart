// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementRepositoryHash() =>
    r'e2c9727bf75729ab35c6e9baac1649ff1d129f25';

/// See also [announcementRepository].
@ProviderFor(announcementRepository)
final announcementRepositoryProvider =
    AutoDisposeProvider<AnnouncementRepository>.internal(
      announcementRepository,
      name: r'announcementRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$announcementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnnouncementRepositoryRef =
    AutoDisposeProviderRef<AnnouncementRepository>;
String _$fetchAnnouncementsHash() =>
    r'761b36f94c1f923ff6b8860c3a790e4c995c576a';

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

/// See also [fetchAnnouncements].
@ProviderFor(fetchAnnouncements)
const fetchAnnouncementsProvider = FetchAnnouncementsFamily();

/// See also [fetchAnnouncements].
class FetchAnnouncementsFamily
    extends Family<AsyncValue<AnnouncementResponse>> {
  /// See also [fetchAnnouncements].
  const FetchAnnouncementsFamily();

  /// See also [fetchAnnouncements].
  FetchAnnouncementsProvider call({int? businessUnitId}) {
    return FetchAnnouncementsProvider(businessUnitId: businessUnitId);
  }

  @override
  FetchAnnouncementsProvider getProviderOverride(
    covariant FetchAnnouncementsProvider provider,
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
  String? get name => r'fetchAnnouncementsProvider';
}

/// See also [fetchAnnouncements].
class FetchAnnouncementsProvider
    extends AutoDisposeFutureProvider<AnnouncementResponse> {
  /// See also [fetchAnnouncements].
  FetchAnnouncementsProvider({int? businessUnitId})
    : this._internal(
        (ref) => fetchAnnouncements(
          ref as FetchAnnouncementsRef,
          businessUnitId: businessUnitId,
        ),
        from: fetchAnnouncementsProvider,
        name: r'fetchAnnouncementsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchAnnouncementsHash,
        dependencies: FetchAnnouncementsFamily._dependencies,
        allTransitiveDependencies:
            FetchAnnouncementsFamily._allTransitiveDependencies,
        businessUnitId: businessUnitId,
      );

  FetchAnnouncementsProvider._internal(
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
    FutureOr<AnnouncementResponse> Function(FetchAnnouncementsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAnnouncementsProvider._internal(
        (ref) => create(ref as FetchAnnouncementsRef),
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
  AutoDisposeFutureProviderElement<AnnouncementResponse> createElement() {
    return _FetchAnnouncementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAnnouncementsProvider &&
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
mixin FetchAnnouncementsRef
    on AutoDisposeFutureProviderRef<AnnouncementResponse> {
  /// The parameter `businessUnitId` of this provider.
  int? get businessUnitId;
}

class _FetchAnnouncementsProviderElement
    extends AutoDisposeFutureProviderElement<AnnouncementResponse>
    with FetchAnnouncementsRef {
  _FetchAnnouncementsProviderElement(super.provider);

  @override
  int? get businessUnitId =>
      (origin as FetchAnnouncementsProvider).businessUnitId;
}

String _$fetchAnnouncementDetailByIDHash() =>
    r'282d2e79cba90bdfa9cedbd72598a6657ef608d9';

/// See also [fetchAnnouncementDetailByID].
@ProviderFor(fetchAnnouncementDetailByID)
const fetchAnnouncementDetailByIDProvider = FetchAnnouncementDetailByIDFamily();

/// See also [fetchAnnouncementDetailByID].
class FetchAnnouncementDetailByIDFamily
    extends Family<AsyncValue<AnnouncementDetailResponse>> {
  /// See also [fetchAnnouncementDetailByID].
  const FetchAnnouncementDetailByIDFamily();

  /// See also [fetchAnnouncementDetailByID].
  FetchAnnouncementDetailByIDProvider call({required int announcementID}) {
    return FetchAnnouncementDetailByIDProvider(announcementID: announcementID);
  }

  @override
  FetchAnnouncementDetailByIDProvider getProviderOverride(
    covariant FetchAnnouncementDetailByIDProvider provider,
  ) {
    return call(announcementID: provider.announcementID);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAnnouncementDetailByIDProvider';
}

/// See also [fetchAnnouncementDetailByID].
class FetchAnnouncementDetailByIDProvider
    extends AutoDisposeFutureProvider<AnnouncementDetailResponse> {
  /// See also [fetchAnnouncementDetailByID].
  FetchAnnouncementDetailByIDProvider({required int announcementID})
    : this._internal(
        (ref) => fetchAnnouncementDetailByID(
          ref as FetchAnnouncementDetailByIDRef,
          announcementID: announcementID,
        ),
        from: fetchAnnouncementDetailByIDProvider,
        name: r'fetchAnnouncementDetailByIDProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchAnnouncementDetailByIDHash,
        dependencies: FetchAnnouncementDetailByIDFamily._dependencies,
        allTransitiveDependencies:
            FetchAnnouncementDetailByIDFamily._allTransitiveDependencies,
        announcementID: announcementID,
      );

  FetchAnnouncementDetailByIDProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.announcementID,
  }) : super.internal();

  final int announcementID;

  @override
  Override overrideWith(
    FutureOr<AnnouncementDetailResponse> Function(
      FetchAnnouncementDetailByIDRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAnnouncementDetailByIDProvider._internal(
        (ref) => create(ref as FetchAnnouncementDetailByIDRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        announcementID: announcementID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AnnouncementDetailResponse> createElement() {
    return _FetchAnnouncementDetailByIDProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAnnouncementDetailByIDProvider &&
        other.announcementID == announcementID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, announcementID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAnnouncementDetailByIDRef
    on AutoDisposeFutureProviderRef<AnnouncementDetailResponse> {
  /// The parameter `announcementID` of this provider.
  int get announcementID;
}

class _FetchAnnouncementDetailByIDProviderElement
    extends AutoDisposeFutureProviderElement<AnnouncementDetailResponse>
    with FetchAnnouncementDetailByIDRef {
  _FetchAnnouncementDetailByIDProviderElement(super.provider);

  @override
  int get announcementID =>
      (origin as FetchAnnouncementDetailByIDProvider).announcementID;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
