// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementRepositoryHash() =>
    r'2b9484d7d167ddc9e68554f6cd112553085051c3';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
