// Menú Lateral de Navegación (Drawer)
// EXPLICAR EN EXPOSICIÓN: Este widget es el menú lateral que se abre desde el AppBar
// Muestra diferentes opciones según el rol del usuario:
// - ADMIN: Productos, Carrito, Dashboard, POS, Gestión de Pedidos (todos los clientes), Reportes, Clientes, Configuración
// - CLIENTE: Productos, Carrito, Mis Pedidos (solo sus propios pedidos), Perfil
// Permite navegar entre pantallas y cerrar sesión

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/pos_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/customers_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

/// Widget del menú lateral de navegación
/// ConsumerWidget permite acceder a providers de Riverpod
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener usuario actual desde el provider de autenticación
    // EXPLICAR: ref.watch escucha cambios en authProvider
    final user = ref.watch(authProvider).user;

    // Verificar si el usuario es administrador
    // EXPLICAR: Solo admins ven todas las opciones del menú
    final isAdmin = user?.role.toString() == 'UserRole.admin';

    return Drawer(
      child: Column(
        children: [
          // Encabezado del drawer con información del usuario
          // EXPLICAR: UserAccountsDrawerHeader es un widget de Material Design
          UserAccountsDrawerHeader(
            // Gradiente de fondo morado
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // Avatar circular con inicial del nombre del usuario
            // EXPLICAR: CircleAvatar crea un círculo con la letra inicial
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                // Obtener primera letra del nombre en mayúscula
                // EXPLICAR: Si no hay nombre, mostrar 'U' de User
                user?.name != null && user!.name.isNotEmpty
                    ? user.name.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(
              user?.name ?? 'Usuario',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(user?.email ?? ''),
          ),

          // Opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Productos - Visible para todos
                _DrawerItem(
                  icon: Icons.inventory,
                  title: 'Productos',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductsScreen()),
                    );
                  },
                ),
                // Carrito - Visible para todos
                _DrawerItem(
                  icon: Icons.shopping_cart,
                  title: 'Carrito',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),

                // Mis Pedidos - Solo para clientes
                if (!isAdmin)
                  _DrawerItem(
                    icon: Icons.receipt_long,
                    title: 'Mis Pedidos',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrdersScreen(),
                        ),
                      );
                    },
                  ),

                if (isAdmin) ...[
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'ADMINISTRACIÓN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.point_of_sale,
                    title: 'Punto de Venta (POS)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const POSScreen()),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assignment,
                    title: 'Gestión de Pedidos',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart,
                    title: 'Reportes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people,
                    title: 'Gestión de Clientes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomersScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.settings,
                    title: 'Configuración',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],

                const Divider(),
                _DrawerItem(
                  icon: Icons.person,
                  title: 'Mi Perfil',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout button
          const Divider(),
          _DrawerItem(
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            color: Colors.red,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
