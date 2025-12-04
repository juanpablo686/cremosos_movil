/// MAIN.DART - Punto de entrada de la aplicación Cremosos
/// ========================================================
/// EXPLICAR EN EXPOSICIÓN:
/// - Este es el archivo principal que inicia la app
/// - ProviderScope permite usar Riverpod para state management
/// - Material3 para diseño moderno según Material Design
/// - Google Fonts para tipografía personalizada
///
/// FLUJO DE LA APP:
/// 1. main() → Inicia la aplicación con ProviderScope
/// 2. CremososApp → Configura tema y navegación
/// 3. AppRoot → Decide si mostrar Login o App principal
/// 4. MainNavigator → Navegación entre pantallas (Home, Productos, Carrito, Perfil)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Importar pantallas
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';

// Importar providers para state management
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';

/// Función principal - punto de entrada de la aplicación
/// EXPLICAR: ProviderScope es necesario para que Riverpod funcione
/// Envuelve toda la app para que los providers estén disponibles
void main() {
  runApp(const ProviderScope(child: CremososApp()));
}

/// Widget raíz de la aplicación
/// EXPLICAR: MaterialApp es el contenedor principal que configura:
/// - El tema de colores (Material3 con seedColor deepPurple)
/// - La tipografía (Google Fonts - Poppins)
/// - Los estilos globales (botones, inputs, cards)
class CremososApp extends StatelessWidget {
  const CremososApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cremosos E-commerce',
      debugShowCheckedModeBanner: false,

      // TEMA DE LA APLICACIÓN
      // EXPLICAR: Material3 es la última versión del sistema de diseño de Google
      theme: ThemeData(
        useMaterial3: true,

        // Esquema de colores generado desde deepPurple
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),

        // Tipografía personalizada con Google Fonts
        textTheme: GoogleFonts.poppinsTextTheme(),

        // Estilo de AppBar (barra superior)
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

        // Estilo de Cards (tarjetas de productos, etc)
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Estilo de botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),

        // Estilo de campos de texto (inputs)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),

      // Pantalla inicial
      home: const AppRoot(),
    );
  }
}

/// Widget raíz que decide qué mostrar según el estado de autenticación
/// EXPLICAR EN EXPOSICIÓN:
/// - ConsumerWidget permite acceder a providers de Riverpod
/// - Observa el estado de autenticación (isAuthenticatedProvider)
/// - Si NO está autenticado → muestra AuthScreen (login)
/// - Si SÍ está autenticado → muestra MainNavigator (app principal)
///
/// IMPORTANTE: Este es el patrón de "protected routes" en Flutter
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el estado de autenticación
    // EXPLICAR: ref.watch re-construye el widget cuando el estado cambia
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // Redirigir según autenticación
    if (!isAuthenticated) {
      // Usuario NO autenticado → mostrar login
      return const AuthScreen();
    }

    // Usuario autenticado → mostrar app principal
    return const MainNavigator();
  }
}

/// Navegador principal con BottomNavigationBar
/// EXPLICAR EN EXPOSICIÓN:
/// - StatefulWidget porque necesita mantener el índice de la pantalla activa
/// - BottomNavigationBar permite navegar entre 4 pantallas principales
/// - Badge en el carrito muestra la cantidad de items
/// - Consumer permite acceder al provider del carrito para el contador
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  // Índice de la pantalla actualmente seleccionada
  int _currentIndex = 0;

  // Lista de pantallas disponibles en la navegación
  // EXPLICAR: Se cambia entre ellas según _currentIndex
  final List<Widget> _screens = [
    const HomeScreen(), // 0: Inicio/Dashboard
    const ProductsScreen(), // 1: Catálogo de productos
    const CartScreen(), // 2: Carrito de compras
    const ProfileScreen(), // 3: Perfil de usuario
  ];

  // Configuración de los items de navegación
  // EXPLICAR: Cada item tiene un icono y una etiqueta
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Inicio'},
    {'icon': Icons.shopping_bag, 'label': 'Productos'},
    {'icon': Icons.shopping_cart, 'label': 'Carrito'},
    {'icon': Icons.person, 'label': 'Perfil'},
  ];

  @override
  Widget build(BuildContext context) {
    // Consumer permite acceder a providers de Riverpod
    return Consumer(
      builder: (context, ref, _) {
        // Obtener cantidad de items en el carrito
        // EXPLICAR: Se muestra como badge en el icono del carrito
        final cartItemCount = ref.watch(cartItemCountProvider);

        return Scaffold(
          // Mostrar la pantalla correspondiente al índice actual
          body: _screens[_currentIndex],

          // Barra de navegación inferior
          // EXPLICAR: Permite cambiar entre las 4 pantallas principales
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,

            // Al tocar un item, cambiar el índice y reconstruir
            onTap: (index) => setState(() => _currentIndex = index),

            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,

            // Generar items de navegación
            items: _navItems
                .asMap()
                .entries
                .map(
                  (entry) => BottomNavigationBarItem(
                    // Si es el carrito (índice 2) y hay items, mostrar badge
                    icon: entry.key == 2 && cartItemCount > 0
                        ? Badge(
                            label: Text('$cartItemCount'),
                            child: Icon(entry.value['icon'] as IconData),
                          )
                        : Icon(entry.value['icon'] as IconData),
                    label: entry.value['label'] as String,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
