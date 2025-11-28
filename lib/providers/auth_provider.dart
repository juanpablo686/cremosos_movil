// providers/auth_provider.dart - Provider de Autenticación

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/users_data.dart';

// Estado de autenticación
class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

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
  AuthNotifier() : super(AuthState()) {
    _loadSavedAuth();
  }

  // Cargar autenticación guardada
  Future<void> _loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getString('user_id');

      if (token != null && userId != null) {
        final user = getUserById(userId);
        if (user != null) {
          state = AuthState(user: user, token: token);
        }
      }
    } catch (e) {
      // Ignorar errores de carga
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simular delay de red (800ms - 1.5s)
      await Future.delayed(
        Duration(milliseconds: 800 + (DateTime.now().millisecond % 700)),
      );

      final response = simulateLogin(email, password);

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.token);
      await prefs.setString('user_id', response.user.id);

      state = AuthState(
        user: response.user,
        token: response.token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Registro
  Future<void> register(RegisterData data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simular delay de red (1s - 2s)
      await Future.delayed(
        Duration(milliseconds: 1000 + (DateTime.now().millisecond % 1000)),
      );

      // Validar que el email no exista
      if (getUserByEmail(data.email) != null) {
        throw Exception('El email ya está registrado');
      }

      // Crear nuevo usuario
      final newUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: data.name,
        email: data.email,
        phone: data.phone,
        role: UserRole.customer,
        createdAt: DateTime.now(),
        preferences: UserPreferences(),
      );

      // Simular token
      final token =
          'mock_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}';

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', newUser.id);

      state = AuthState(
        user: newUser,
        token: token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    state = AuthState();
  }

  // Actualizar perfil
  Future<void> updateProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simular delay de API
      await Future.delayed(
        Duration(milliseconds: 500 + (DateTime.now().millisecond % 500)),
      );

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Refresh token (simulado)
  Future<void> refreshToken() async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Simular delay de API
      await Future.delayed(const Duration(milliseconds: 800));

      final newToken =
          'mock_token_${state.user!.id}_${DateTime.now().millisecondsSinceEpoch}';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', newToken);

      state = state.copyWith(token: newToken, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Verificar sesión activa
  Future<bool> verifySession() async {
    if (state.token == null || state.user == null) return false;

    try {
      // Simular verificación de API
      await Future.delayed(const Duration(milliseconds: 500));

      // En una app real, verificaríamos el token con el backend
      // Por ahora, verificamos que el usuario exista
      final user = getUserById(state.user!.id);
      if (user == null || !user.isActive) {
        await logout();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Cambiar contraseña (simulado)
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simular delay de API
      await Future.delayed(const Duration(milliseconds: 1000));

      // En una app real, validaríamos con el backend
      if (currentPassword.length < 6 || newPassword.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

// Provider de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
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
