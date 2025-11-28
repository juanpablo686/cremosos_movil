// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../data/users_data.dart' show getUserOrders;
import '../models/cart.dart';
import 'auth_screen.dart';
import 'reports_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAuthenticated || currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'No has iniciado sesión',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                ),
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    final userOrders = getUserOrders(currentUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: currentUser.avatar != null
                          ? ClipOval(
                              child: Image.network(
                                currentUser.avatar!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Text(
                              currentUser.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.deepPurple,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser.email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (currentUser.phone != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        currentUser.phone!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                    if (isAdmin) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'ADMINISTRADOR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Admin Dashboard Button
            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.deepPurple),
                title: const Text(
                  'Panel de Administración',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen()),
                ),
              ),

            const Divider(),

            // Account Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mi cuenta',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.shopping_bag_outlined,
                          value: '${userOrders.length}',
                          label: 'Pedidos',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_shipping_outlined,
                          value:
                              '${userOrders.where((o) => o.status == OrderStatus.delivered).length}',
                          label: 'Entregados',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.schedule_outlined,
                          value:
                              '${userOrders.where((o) => o.status == OrderStatus.processing || o.status == OrderStatus.shipped).length}',
                          label: 'En proceso',
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.monetization_on_outlined,
                          value:
                              '\$${userOrders.where((o) => o.status == OrderStatus.delivered).fold<int>(0, (sum, o) => sum + o.total)}',
                          label: 'Total gastado',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  Text(
                    'Acciones rápidas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _ActionCard(
                    icon: Icons.edit_outlined,
                    title: 'Editar perfil',
                    subtitle: 'Actualiza tu información personal',
                    color: Colors.blue,
                    onTap: () => _showEditProfileDialog(context, currentUser),
                  ),
                  _ActionCard(
                    icon: Icons.location_on_outlined,
                    title: 'Mis direcciones',
                    subtitle:
                        '${currentUser.addresses.length} direcciones guardadas',
                    color: Colors.green,
                    onTap: () => _showAddressesDialog(context, currentUser),
                  ),
                  _ActionCard(
                    icon: Icons.payment_outlined,
                    title: 'Métodos de pago',
                    subtitle:
                        '${currentUser.paymentMethods.length} métodos guardados',
                    color: Colors.orange,
                    onTap: () =>
                        _showPaymentMethodsDialog(context, currentUser),
                  ),
                  _ActionCard(
                    icon: Icons.favorite_border,
                    title: 'Favoritos',
                    subtitle: 'Productos que te gustan',
                    color: Colors.red,
                    onTap: () => _showFavoritesDialog(context),
                  ),
                  _ActionCard(
                    icon: Icons.notifications_outlined,
                    title: 'Notificaciones',
                    subtitle: 'Configura tus preferencias',
                    color: Colors.purple,
                    onTap: () => _showNotificationsDialog(context),
                  ),
                  _ActionCard(
                    icon: Icons.lock_outline,
                    title: 'Seguridad',
                    subtitle: 'Cambiar contraseña',
                    color: Colors.deepOrange,
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _ActionCard(
                    icon: Icons.help_outline,
                    title: 'Ayuda y soporte',
                    subtitle: '¿Necesitas ayuda?',
                    color: Colors.teal,
                    onTap: () => _showHelpDialog(context),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Historial de pedidos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (userOrders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No tienes pedidos aún',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...userOrders.map((order) {
                      final statusColor = switch (order.status) {
                        OrderStatus.pending => Colors.orange,
                        OrderStatus.processing => Colors.blue,
                        OrderStatus.shipped => Colors.purple,
                        OrderStatus.delivered => Colors.green,
                        OrderStatus.cancelled => Colors.red,
                      };

                      final statusText = switch (order.status) {
                        OrderStatus.pending => 'Pendiente',
                        OrderStatus.processing => 'Procesando',
                        OrderStatus.shipped => 'Enviado',
                        OrderStatus.delivered => 'Entregado',
                        OrderStatus.cancelled => 'Cancelado',
                      };

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pedido #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${order.items.length} productos',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${order.total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fecha: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, currentUser) {
    final nameController = TextEditingController(text: currentUser.name);
    final phoneController =
        TextEditingController(text: currentUser.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar perfil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil actualizado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddressesDialog(BuildContext context, currentUser) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mis direcciones'),
        content: SizedBox(
          width: double.maxFinite,
          child: currentUser.addresses.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No tienes direcciones guardadas'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentUser.addresses.length,
                  itemBuilder: (context, index) {
                    final address = currentUser.addresses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          address.isDefault ? Icons.home : Icons.location_on,
                          color: Colors.deepPurple,
                        ),
                        title: Text(address.street),
                        subtitle: Text(
                          '${address.city}, ${address.state} ${address.postalCode}',
                        ),
                        trailing: address.isDefault
                            ? Chip(
                                label: const Text(
                                  'Principal',
                                  style: TextStyle(fontSize: 10),
                                ),
                                backgroundColor: Colors.green.shade100,
                              )
                            : null,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _showAddAddressDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva dirección'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Calle y número',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Colonia',
                  prefixIcon: Icon(Icons.apartment),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: const TextField(
                      decoration: InputDecoration(
                        labelText: 'Ciudad',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const TextField(
                      decoration: InputDecoration(
                        labelText: 'C.P.',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dirección agregada correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog(BuildContext context, currentUser) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Métodos de pago'),
        content: SizedBox(
          width: double.maxFinite,
          child: currentUser.paymentMethods.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No tienes métodos de pago guardados'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentUser.paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = currentUser.paymentMethods[index];
                    final icon = method.type == 'card'
                        ? Icons.credit_card
                        : Icons.account_balance_wallet;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(icon, color: Colors.deepPurple),
                        title: Text(method.name),
                        subtitle: Text('**** ${method.lastFour}'),
                        trailing: method.isDefault
                            ? Chip(
                                label: const Text(
                                  'Principal',
                                  style: TextStyle(fontSize: 10),
                                ),
                                backgroundColor: Colors.green.shade100,
                              )
                            : null,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Método de pago agregado'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Favoritos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aún no tienes productos favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notificaciones'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text('Ofertas y promociones'),
              subtitle: const Text('Recibe notificaciones de descuentos'),
            ),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text('Actualizaciones de pedidos'),
              subtitle: const Text('Estado de tus pedidos'),
            ),
            SwitchListTile(
              value: false,
              onChanged: (v) {},
              title: const Text('Nuevos productos'),
              subtitle: const Text('Cuando hay productos nuevos'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferencias guardadas'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña actualizada correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ayuda y soporte'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HelpItem(
                icon: Icons.phone,
                title: 'Teléfono',
                subtitle: '+52 55 1234 5678',
              ),
              _HelpItem(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'soporte@cremosos.com',
              ),
              _HelpItem(
                icon: Icons.chat,
                title: 'Chat en vivo',
                subtitle: 'Lun-Vie 9am-6pm',
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.question_answer),
                label: const Text('Preguntas frecuentes'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.policy),
                label: const Text('Términos y condiciones'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.privacy_tip),
                label: const Text('Política de privacidad'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// Widgets adicionales
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
