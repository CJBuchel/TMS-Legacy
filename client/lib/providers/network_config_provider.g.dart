// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverAddressHash() => r'792fd1acd561589b1b662461b078933cfa172210';

/// See also [serverAddress].
@ProviderFor(serverAddress)
final serverAddressProvider = AutoDisposeProvider<String>.internal(
  serverAddress,
  name: r'serverAddressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServerAddressRef = AutoDisposeProviderRef<String>;
String _$serverIpHash() => r'7f9b8102f8663ce35212f5b18d521bd24849f723';

/// See also [ServerIp].
@ProviderFor(ServerIp)
final serverIpProvider = AutoDisposeNotifierProvider<ServerIp, String>.internal(
  ServerIp.new,
  name: r'serverIpProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverIpHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServerIp = AutoDisposeNotifier<String>;
String _$serverPortHash() => r'38c886f1c18ef89ae20f4c2f9f43c0b38b80040b';

/// See also [ServerPort].
@ProviderFor(ServerPort)
final serverPortProvider =
    AutoDisposeNotifierProvider<ServerPort, int>.internal(
      ServerPort.new,
      name: r'serverPortProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$serverPortHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServerPort = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
