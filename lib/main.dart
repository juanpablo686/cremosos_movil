// Importaciones necesarias para la aplicación
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'providers/auth_provider.dart';

// Punto de entrada de la aplicación
void main() {
  // ProviderScope es necesario para usar Riverpod (gestión de estado)
  runApp(const ProviderScope(child: MyApp()));
}

// Widget principal de la aplicación
// ConsumerWidget permite escuchar cambios en los providers
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el estado de autenticación
    final authState = ref.watch(authProvider);
    final user = authState.user;
    // Verificar si el usuario es administrador
    final isAdmin = user?.role.toString() == 'UserRole.admin';

    // Determinar qué pantalla mostrar según el estado de autenticación y rol
    Widget homeWidget;
    if (authState.isAuthenticated) {
      // Admin ve Dashboard, clientes ven Productos
      homeWidget = isAdmin ? const HomeScreen() : const ProductsScreen();
    } else {
      // Usuario no autenticado ve pantalla de login
      homeWidget = const AuthScreen();
    }

    return MaterialApp(
      title: 'Cremosos E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: homeWidget,
    );
  }
}
