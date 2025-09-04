// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'82228ecbf145da75f6eb34887a374f5f760b4355';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
