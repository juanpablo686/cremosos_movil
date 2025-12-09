// providers/auth_provider.dart - Provider de Autenticación

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

// Provider de ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider de AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthService(apiService);
});

// Estado de autenticación
class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.token, this.isLoading = false, this.error});

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null && token != null;
  bool get isAdmin => user?.role == UserRole.admin;
}

// Notificador de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final ApiService _apiService;

  AuthNotifier(this._authService, this._apiService) : super(AuthState()) {
    _loadSavedAuth();
  }

  // Cargar autenticación guardada
  Future<void> _loadSavedAuth() async {
    try {
      final token = await _apiService.getAuthToken();
      if (token != null) {
        // Obtener perfil del usuario desde la API
        final profileData = await _authService.getProfile();
        final user = User.fromJson(profileData['user']);

        state = AuthState(user: user, token: token);
      }
    } catch (e) {
      // Si hay error (token expirado), limpiar
      await _apiService.clearAuthToken();
    }
  }

  // Login con API REAL
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Llamar a la API REAL
      final response = await _authService.login(
        email: email,
        password: password,
      );

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
