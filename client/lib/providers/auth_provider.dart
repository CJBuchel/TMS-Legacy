import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/local_storage.dart';
import 'package:tms/helpers/permissions.dart';
import 'package:tms/models/user.dart';
import 'package:tms/providers/network_config_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Authentication extends _$Authentication {
  static const _usernameKey = 'username';
  static const _jwtKey = 'jwt';
  static const _rolesKey = 'roles';

  String get username => localStorage.getString(_usernameKey) ?? "";
  List<Role> get roles {
    final roles = localStorage.getStringList(_rolesKey) ?? <String>[];
    return roles.map((role) => getRoleFromString(role)).nonNulls.toList();
  }

  Future<bool> _validateToken(String serverAddress) async {
    // get JWT token from storage
    final token = localStorage.get(_jwtKey) ?? "";

    // send request to server
    try {
      final response = await http.get(
        Uri.parse('http://$serverAddress/api/user/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print response
      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      Logger().e('Error occurred while validating token: $e');
    }
    return false;
  }

  bool hasPermission(Role necessary) {
    // Check if user has the required permissions
    return roles.any((role) {
      Logger().i('Checking permission for role: $role');
      return RoleGraph.instance.hasPermission(role, necessary);
    });
  }

  @override
  Future<bool> build() async {
    final serverAddress = ref.watch(serverAddressProvider);
    return await _validateToken(serverAddress);
  }

  Future<bool> login(String username, String password) async {
    final serverAddress = ref.watch(serverAddressProvider);
    try {
      final response = await http.post(
        Uri.parse('http://$serverAddress/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == HttpStatus.ok) {
        Logger().i('Login Response status: ${response.statusCode}');
        Logger().i('Login Response body: ${response.body}');
        final data = jsonDecode(response.body);
        final authResponse = AuthenticationResponse.fromJson(data);
        localStorage.setString(_usernameKey, username);
        localStorage.setString(_jwtKey, authResponse.token);
        localStorage.setStringList(_rolesKey, authResponse.roles);
        state = AsyncValue.data(true);
        return true;
      } else {
        Logger().e('Login failed: ${response.body}');
        state = AsyncValue.error('Login failed', StackTrace.current);
      }
    } catch (e) {
      Logger().e('Error occurred while logging in: $e');
      state = AsyncValue.error('Login failed', StackTrace.current);
    }

    return false;
  }

  void logout() {
    localStorage.remove(_usernameKey);
    localStorage.remove(_jwtKey);
    localStorage.remove(_rolesKey);
    state = const AsyncValue.data(false);
  }
}
