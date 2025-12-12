// services/users_service.dart - Servicio de gestión de usuarios

import '../models/user.dart';
import 'api_service.dart';

class UsersService {
  final ApiService _apiService;

  UsersService(this._apiService);

  /// Obtener lista de usuarios (solo admin)
  Future<Map<String, dynamic>> getUsers({
    String? search,
    String? role,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }

      final response = await _apiService.get(
        '/admin/users',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final users = (response.data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();

        return {'users': users, 'meta': response.data['meta']};
      }

      throw Exception('Error al obtener usuarios');
    } catch (e) {
      print('Error en getUsers: $e');
      rethrow;
    }
  }

  /// Obtener detalle de un usuario
  Future<User> getUserById(String userId) async {
    try {
      final response = await _apiService.get('/admin/users/$userId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      }

      throw Exception('Error al obtener usuario');
    } catch (e) {
      print('Error en getUserById: $e');
      rethrow;
    }
  }

  /// Crear nuevo usuario
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/users',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': role,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al crear usuario');
    } catch (e) {
      print('Error en createUser: $e');
      rethrow;
    }
  }

  /// Actualizar usuario
  Future<User> updateUser({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? role,
    Map<String, dynamic>? address,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (role != null) data['role'] = role;
      if (address != null) data['address'] = address;

      final response = await _apiService.put(
        '/admin/users/$userId',
        data: data,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      }

      throw Exception(
        response.data['message'] ?? 'Error al actualizar usuario',
      );
    } catch (e) {
      print('Error en updateUser: $e');
      rethrow;
    }
  }

  /// Eliminar usuario
  Future<void> deleteUser(String userId) async {
    try {
      final response = await _apiService.delete('/admin/users/$userId');

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Error al eliminar usuario',
        );
      }
    } catch (e) {
      print('Error en deleteUser: $e');
      rethrow;
    }
  }
}
