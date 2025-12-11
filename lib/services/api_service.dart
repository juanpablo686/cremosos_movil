// Importaciones necesarias para realizar peticiones HTTP
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// Servicio base para todas las peticiones HTTP a la API
/// Maneja autenticación automática, logging y manejo de errores
/// EXPLICAR EN EXPOSICIÓN: Dio es una librería HTTP potente que permite:
/// - Interceptores (agregar token automáticamente)
/// - Manejo de errores centralizado
/// - Logging de peticiones para debugging
/// - Retry automático en caso de fallo

class ApiService {
  // Instancia de Dio para hacer peticiones HTTP
  late final Dio _dio;

  // Almacenamiento seguro para el token JWT
  // EXPLICAR: flutter_secure_storage usa el Keychain en iOS y KeyStore en Android
  final _secureStorage = const FlutterSecureStorage();

  // Clave para guardar el token en storage
  static const String _tokenKey = 'auth_token';

  // Constructor: Configura Dio con opciones base
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectionTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Agregar interceptores
    _setupInterceptors();
  }

  /// Configura interceptores de Dio
  /// EXPLICAR: Los interceptores permiten modificar requests/responses automáticamente
  void _setupInterceptors() {
    _dio.interceptors.add(
      // Interceptor para agregar token de autenticación automáticamente
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener token guardado
          final token = await getAuthToken();

          // Si existe token, agregarlo al header Authorization
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            '❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          print('MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );

    // Logger para ver detalles de peticiones en consola (solo en desarrollo)
    // EXPLICAR: Esto ayuda a debuggear problemas con la API
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  /// Métodos HTTP - EXPLICAR cada uno en exposición

  /// GET: Obtener datos del servidor
  /// Ejemplo: Listar productos, obtener perfil de usuario
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST: Crear nuevos recursos en el servidor
  /// Ejemplo: Login, registro, crear orden
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT: Actualizar recursos existentes completamente
  /// Ejemplo: Actualizar perfil, modificar cantidad en carrito
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE: Eliminar recursos del servidor
  /// Ejemplo: Eliminar producto del carrito, eliminar dirección
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Manejo centralizado de errores HTTP
  /// EXPLICAR EN EXPOSICIÓN: Los códigos HTTP tienen significados específicos
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // Timeout: El servidor tardó mucho en responder
        return Exception('Error de conexión: Tiempo de espera agotado');

      case DioExceptionType.badResponse:
        // El servidor respondió con un error
        final statusCode = error.response?.statusCode;

        // EXPLICAR: Códigos de estado HTTP en la exposición
        switch (statusCode) {
          case 400:
            // Bad Request: Datos inválidos enviados
            return Exception(
              'Solicitud inválida: ${error.response?.data['message'] ?? 'Datos incorrectos'}',
            );
          case 401:
            // Unauthorized: No autenticado o token expirado
            return Exception(
              'No autorizado: Por favor inicie sesión nuevamente',
            );
          case 403:
            // Forbidden: Autenticado pero sin permisos
            return Exception(
              'Acceso denegado: No tiene permisos para esta acción',
            );
          case 404:
            // Not Found: Recurso no encontrado
            return Exception('No encontrado: El recurso solicitado no existe');
          case 500:
            // Internal Server Error: Error en el servidor
            return Exception('Error del servidor: Por favor intente más tarde');
          default:
            return Exception(
              'Error: ${error.response?.data['message'] ?? 'Error desconocido'}',
            );
        }

      case DioExceptionType.cancel:
        // Request cancelado por el usuario
        return Exception('Solicitud cancelada');

      case DioExceptionType.unknown:
        // Error de red (sin internet, servidor caído)
        return Exception('Error de conexión: Verifique su conexión a internet');

      default:
        return Exception('Error inesperado: ${error.message}');
    }
  }

  // Métodos para gestión de token JWT
  // EXPLICAR: JWT (JSON Web Token) es el estándar para autenticación en APIs REST

  /// Guardar token de autenticación de forma segura
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Obtener token de autenticación guardado
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Eliminar token (logout)
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Verificar si hay token guardado
  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
