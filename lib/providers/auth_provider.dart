// Provider de Autenticación
// EXPLICAR EN EXPOSICIÓN: Este archivo maneja todo el estado de autenticación de la app
// usando Riverpod para gestión de estado reactiva y global
// Riverpod es una librería que permite compartir estado entre múltiples pantallas

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

// Provider de ApiService
// EXPLICAR: Provider es como un singleton que se puede acceder desde cualquier parte
// Provee la instancia única de ApiService para hacer peticiones HTTP
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider de AuthService
// EXPLICAR: Provee la instancia del servicio de autenticación
// ref.read permite leer otros providers para inyectar dependencias
// Esto es inyección de dependencias: AuthService necesita ApiService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthService(apiService);
});

// Clase que representa el Estado de Autenticación
// EXPLICAR: Contiene toda la información del usuario logueado y estado de carga
/// Estado inmutable que contiene información de autenticación
class AuthState {
  final User? user; // Usuario actual (null si no está autenticado)
  final String? token; // Token JWT para autenticación en la API
  final bool
  isLoading; // Indica si hay una operación de auth en progreso (login, registro)
  final String? error; // Mensaje de error si algo falla

  // Constructor
  AuthState({this.user, this.token, this.isLoading = false, this.error});

  /// Método para crear una copia modificada del estado
  /// EXPLICAR: En Riverpod/Flutter, los estados son inmutables
  /// No se modifican directamente, se crean nuevas copias con cambios
  /// Esto permite detectar cambios y actualizar la UI automáticamente
  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user:
          user ?? this.user, // Si se pasa user, usarlo, sino mantener el actual
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Importante: error NO usa ??, puede ser null
    );
  }

  // Getters útiles para verificar estado
  // EXPLICAR: Son propiedades calculadas basadas en el estado actual
  bool get isAuthenticated =>
      user != null && token != null; // ¿Usuario logueado?
  bool get isAdmin => user?.role == UserRole.admin; // ¿Es administrador?
}

/// Notificador de autenticación
/// EXPLICAR: StateNotifier es una clase que maneja cambios de estado
/// Cuando cambia el estado, notifica a todos los widgets que lo escuchan
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService; // Servicio para llamar a la API
  final ApiService _apiService; // Servicio para gestionar token

  // Constructor: inicializa con estado vacío y carga auth guardada
  AuthNotifier(this._authService, this._apiService) : super(AuthState()) {
    _loadSavedAuth(); // Intentar cargar sesión guardada al iniciar
  }

  /// Cargar autenticación guardada
  /// EXPLICAR: Cuando abres la app, intenta recuperar el token guardado
  /// Si existe token válido, obtiene perfil del usuario y restaura sesión
  Future<void> _loadSavedAuth() async {
    try {
      // Intentar obtener token JWT guardado en storage seguro
      final token = await _apiService.getAuthToken();
      if (token != null) {
        // Si hay token, obtener perfil del usuario desde la API
        final profileData = await _authService.getProfile();
        final user = User.fromJson(profileData['user']);

        // Actualizar estado con usuario y token
        state = AuthState(user: user, token: token);
      }
    } catch (e) {
      // Si hay error (token expirado o inválido), limpiar
      await _apiService.clearAuthToken();
    }
  }

  /// Login con API REAL
  /// EXPLICAR: Autentica al usuario con email y contraseña
  /// 1. Muestra loading
  /// 2. Llama a la API
  /// 3. Guarda token y actualiza estado
  /// 4. Oculta loading
  Future<void> login(String email, String password) async {
    // Actualizar estado: mostrar loading, limpiar error
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Llamar a la API REAL para hacer login
      final response = await _authService.login(
        email: email,
        password: password,
      );

      // Debug: imprimir respuesta para verificar
      print('🔍 AuthProvider response: $response');
      print('🔍 AuthProvider response[user]: ${response['user']}');
      print('🔍 AuthProvider response[token]: ${response['token']}');

      // Validar que los datos existan
      if (response['user'] == null) {
        throw Exception('Datos de usuario no encontrados en la respuesta');
      }

      if (response['token'] == null) {
        throw Exception('Token no encontrado en la respuesta');
      }

      // Extraer usuario y token de la respuesta
      final userMap = response['user'] as Map<String, dynamic>;
      final user = User.fromJson(userMap);
      final token = response['token'] as String;

      state = AuthState(user: user, token: token, isLoading: false);
    } catch (e) {
      print('❌ Error en login: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Registro con API REAL
  Future<void> register(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.register(
        name: data['name'],
        email: data['email'],
        password: data['password'],
      );

      final user = User.fromJson(response['user']);
      final token = response['token'];

      state = AuthState(user: user, token: token, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _apiService.clearAuthToken();
    state = AuthState();
  }

  // Actualizar perfil
  Future<void> updateProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Convertir usuario a Map para enviar a API
      final updates = {'name': updatedUser.name, 'phone': updatedUser.phone};

      await _authService.updateProfile(updates);

      // Refrescar perfil desde API
      await refreshProfile();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Refrescar perfil desde API
  Future<void> refreshProfile() async {
    try {
      final profileData = await _authService.getProfile();
      final user = User.fromJson(profileData['user']);

      state = state.copyWith(user: user);
    } catch (e) {
      // Ignorar errores
    }
  }

  // Alias para refreshProfile (usado por profile_screen)
  Future<void> refreshUser() async {
    await refreshProfile();
  }
}

// Provider de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final apiService = ref.read(apiServiceProvider);
  return AuthNotifier(authService, apiService);
});

// Provider del usuario actual
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Provider de estado de autenticación
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// Provider de rol admin
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAdmin;
});
