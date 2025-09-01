import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/local_storage.dart';
import 'package:tms/providers/network_config_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Authentication extends _$Authentication {
  static const _usernameKey = 'username';
  static const _jwtKey = 'jwt';
  static const _rolesKey = 'roles';

  Future<bool> _validateToken(String serverAddress) async {
    print("Validating token with server at $serverAddress");
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
      print('Validation Response status: ${response.statusCode}');
      print('Validation Response body: ${response.body}');
      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      print('Error occurred while validating token: $e');
    }
    return false;
  }

  @override
  Future<bool> build() async {
    print("Building auth provider");
    final serverAddress = ref.watch(serverAddressProvider);
    return await _validateToken(serverAddress);
  }

  Future<bool> login(String username, String password) async {
    final serverAddress = ref.watch(serverAddressProvider);
    final response = await http.post(
      Uri.parse('http://$serverAddress/api/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == HttpStatus.ok) {
      // print response
      print('Login Response status: ${response.statusCode}');
      print('Login Response body: ${response.body}');
      // final data = jsonDecode(response.body);
      // localStorage.setString(_usernameKey, data['username']);
      // localStorage.setString(_jwtKey, data['token']);
      // localStorage.setString(_rolesKey, data['roles']);
      return true;
    }

    return false;
  }
}
