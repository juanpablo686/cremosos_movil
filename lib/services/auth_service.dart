import '../config/api_config.dart';
import 'api_service.dart';

/// Servicio de Autenticación
/// EXPLICAR EN EXPOSICIÓN: Este servicio maneja todas las operaciones relacionadas
/// con la autenticación de usuarios (login, registro, obtener perfil)

class AuthService {
  final ApiService _apiService;

  // Inyección de dependencias - Explicar patrón
  AuthService(this._apiService);

  /// LOGIN - POST /api/auth/login
  /// Autenticar usuario con email y contraseña
  /// EXPLICAR: Envía credenciales y recibe token JWT del servidor
  ///
  /// Request body: { "email": "user@example.com", "password": "123456" }
  /// Response: { "token": "eyJhbGc...", "user": {...} }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Preparar datos para enviar al servidor
      final data = {'email': email, 'password': password};

      // Hacer petición POST al endpoint de login
      final response = await _apiService.post(
        ApiConfig.loginEndpoint,
        data: data,
      );

      // Si la respuesta es exitosa (status 200-299)
      if (response.statusCode == 200) {
        // Validar que response.data no sea null
        if (response.data == null) {
          throw Exception('Respuesta vacía del servidor');
        }

        print('📥 Login response.data type: ${response.data.runtimeType}');
        print('📥 Login response.data: ${response.data}');

        // El backend retorna: { "success": true, "data": { "token": "...", "user": {...} } }
        final responseMap = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : throw Exception(
                'Respuesta del servidor no es un objeto JSON válido',
              );

        if (responseMap['data'] == null) {
          throw Exception('Datos de autenticación no encontrados');
        }

        final responseData = responseMap['data'] as Map<String, dynamic>;

        // Guardar token JWT de forma segura
        // EXPLICAR: El token se usa para autenticar futuras peticiones
        if (responseData['token'] != null) {
          await _apiService.setAuthToken(responseData['token'] as String);
        }

        return responseData;
      } else {
        throw Exception('Error en login: ${response.statusMessage}');
      }
    } catch (e) {
      // Re-lanzar excepción para que sea manejada por el provider
      rethrow;
    }
  }

  /// REGISTER - POST /api/auth/register
  /// Registrar nuevo usuario en el sistema
  /// EXPLICAR: Crea una cuenta nueva y retorna token para login automático
  ///
  /// Request body: { "name": "Juan", "email": "juan@example.com", "password": "123456" }
  /// Response: { "token": "eyJhbGc...", "user": {...} }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = {'name': name, 'email': email, 'password': password};

      final response = await _apiService.post(
        ApiConfig.registerEndpoint,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // El backend retorna: { "success": true, "data": { "token": "...", "user": {...} } }
        final responseData = response.data['data'] as Map<String, dynamic>;

        // Guardar token automáticamente después de registro exitoso
        if (responseData['token'] != null) {
          await _apiService.setAuthToken(responseData['token']);
        }

        return responseData;
      } else {
        throw Exception('Error en registro: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET PROFILE - GET /api/users/profile
  /// Obtener información del perfil del usuario autenticado
  /// EXPLICAR: Requiere token JWT en el header Authorization
  ///
  /// Headers: { "Authorization": "Bearer eyJhbGc..." }
  /// Response: { "id": 1, "name": "Juan", "email": "juan@example.com", ... }
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get(ApiConfig.profileEndpoint);

      if (response.statusCode == 200) {
        // El backend retorna: { "success": true, "data": {...user} }
        // Envolver en "user" para mantener consistencia con login
        return {'user': response.data['data']};
      } else {
        throw Exception('Error al obtener perfil');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE PROFILE - PUT /api/users/profile
  /// Actualizar información del perfil del usuario
  /// EXPLICAR: PUT actualiza el recurso completo en el servidor
  ///
  /// Request body: { "name": "Juan Pablo", "phone": "+57 300 123 4567" }
  /// Response: { "id": 1, "name": "Juan Pablo", "phone": "+57 300 123 4567", ... }
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiService.put(
        ApiConfig.updateProfileEndpoint,
        data: updates,
      );

      if (response.statusCode == 200) {
        // El backend retorna: { "success": true, "data": {...user} }
        // Envolver en "user" para mantener consistencia
        return {'user': response.data['data']};
      } else {
        throw Exception('Error al actualizar perfil');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// LOGOUT - Cerrar sesión del usuario
  /// EXPLICAR: Solo elimina el token localmente, opcionalmente se puede
  /// hacer una petición al servidor para invalidar el token
  Future<void> logout() async {
    try {
      // Eliminar token del almacenamiento seguro
      await _apiService.clearAuthToken();

      // Opcionalmente, aquí se podría hacer una petición POST /api/auth/logout
      // para invalidar el token en el servidor (lista negra de tokens)
    } catch (e) {
      rethrow;
    }
  }

  /// Verificar si el usuario está autenticado
  /// EXPLICAR: Verifica si existe un token guardado localmente
  Future<bool> isAuthenticated() async {
    return await _apiService.hasAuthToken();
  }
}
