// services/roles_service.dart - Servicio de gestión de roles

import '../models/role.dart';
import 'api_service.dart';

class RolesService {
  final ApiService _apiService;

  RolesService(this._apiService);

  /// Obtener lista de roles
  Future<List<Role>> getRoles() async {
    try {
      final response = await _apiService.get('/roles');

      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((json) => Role.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener roles');
    } catch (e) {
      print('Error en getRoles: $e');
      rethrow;
    }
  }

  /// Obtener detalle de un rol
  Future<Role> getRoleById(String roleId) async {
    try {
      final response = await _apiService.get('/roles/$roleId');

      if (response.data['success'] == true) {
        return Role.fromJson(response.data['data']);
      }

      throw Exception('Error al obtener rol');
    } catch (e) {
      print('Error en getRoleById: $e');
      rethrow;
    }
  }

  /// Crear nuevo rol
  Future<Role> createRole({
    required String name,
    required String displayName,
    required String description,
    required List<String> permissions,
  }) async {
    try {
      final response = await _apiService.post(
        '/roles',
        data: {
          'name': name,
          'displayName': displayName,
          'description': description,
          'permissions': permissions,
        },
      );

      if (response.data['success'] == true) {
        return Role.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al crear rol');
    } catch (e) {
      print('Error en createRole: $e');
      rethrow;
    }
  }

  /// Actualizar rol
  Future<Role> updateRole({
    required String roleId,
    String? displayName,
    String? description,
    List<String>? permissions,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (displayName != null) data['displayName'] = displayName;
      if (description != null) data['description'] = description;
      if (permissions != null) data['permissions'] = permissions;

      final response = await _apiService.put('/roles/$roleId', data: data);

      if (response.data['success'] == true) {
        return Role.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al actualizar rol');
    } catch (e) {
      print('Error en updateRole: $e');
      rethrow;
    }
  }

  /// Eliminar rol
  Future<void> deleteRole(String roleId) async {
    try {
      final response = await _apiService.delete('/roles/$roleId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error al eliminar rol');
      }
    } catch (e) {
      print('Error en deleteRole: $e');
      rethrow;
    }
  }
}
