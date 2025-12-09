// screens/admin_menu_screen.dart - Menú de Administración

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'admin/users_management_screen.dart';
import 'admin/roles_management_screen.dart';
import 'admin/products_management_screen.dart';
import 'admin/suppliers_management_screen.dart';
import 'admin/purchases_management_screen.dart';
import 'admin/sales_management_screen.dart';
import 'pos/pos_screen.dart';

class AdminMenuScreen extends ConsumerWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Usuarios - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.people,
                title: 'Gestión de Usuarios',
                subtitle: 'Crear, editar y eliminar usuarios',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UsersManagementScreen(),
                    ),
                  );
                },
              ),
            // Punto de Venta - Todos los empleados
            _buildMenuCard(
              context,
              icon: Icons.point_of_sale,
              title: 'Punto de Venta',
              subtitle: 'Registrar ventas directas',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const POSScreen()),
                );
              },
            ),
            // Productos - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.inventory,
                title: 'Gestión de Productos',
                subtitle: 'Crear, editar y eliminar productos',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductsManagementScreen(),
                    ),
                  );
                },
              ),
            // Proveedores - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.shopping_cart,
                title: 'Proveedores',
                subtitle: 'Gestionar proveedores',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SuppliersManagementScreen(),
                    ),
                  );
                },
              ),
            // Roles - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.admin_panel_settings,
                title: 'Roles y Permisos',
                subtitle: 'Gestionar roles del sistema',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RolesManagementScreen(),
                    ),
                  );
                },
              ),
            // Compras - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.shopping_bag,
                title: 'Compras',
                subtitle: 'Gestionar compras a proveedores',
                color: Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PurchasesManagementScreen(),
                    ),
                  );
                },
              ),
            // Ventas - SOLO ADMIN
            if (isAdmin)
              _buildMenuCard(
                context,
                icon: Icons.sell,
                title: 'Ventas',
                subtitle: 'Historial de ventas realizadas',
                color: Colors.amber,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SalesManagementScreen(),
                    ),
                  );
                },
              ),
            // Reportes - Todos
            _buildMenuCard(
              context,
              icon: Icons.analytics,
              title: 'Reportes',
              subtitle: 'Ver reportes y estadísticas',
              color: Colors.teal,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ir a la sección de Reportes en el menú'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
