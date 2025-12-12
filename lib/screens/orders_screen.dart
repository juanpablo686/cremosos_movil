// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_drawer.dart';
import '../services/api_service.dart';
import '../services/order_service.dart';
import '../providers/auth_provider.dart';

// Provider para cargar pedidos desde la API
// FutureProvider.family permite pasar parámetros (filtro de estado)
final ordersProvider = FutureProvider.family<List<dynamic>, String?>((
  ref,
  filter,
) async {
  final apiService = ApiService();
  final orderService = OrderService(apiService);
  try {
    // Obtener pedidos desde el backend
    final response = await orderService.getOrders();
    final orders = response['data'] ?? [];

    // Filtrar por estado si se especifica
    if (filter != null && filter != 'all') {
      return (orders as List)
          .where((order) => order['status'] == filter)
          .toList();
    }
    return orders;
  } catch (e) {
    print('Error cargando pedidos: $e');
    return [];
  }
});

// Pantalla de gestión de pedidos (para admin) o mis pedidos (para clientes)
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  // Filtro actualmente seleccionado
  String _selectedFilter = 'all';

  // Etiquetas de texto para cada estado de pedido
  final Map<String, String> _statusLabels = {
    'all': 'Todos',
    'pending': 'Pendientes',
    'processing': 'En Proceso',
    'shipped': 'Enviados',
    'delivered': 'Entregados',
    'cancelled': 'Cancelados',
  };

  // Colores asociados a cada estado
  final Map<String, Color> _statusColors = {
    'pending': Colors.orange,
    'processing': Colors.blue,
    'shipped': Colors.purple,
    'delivered': Colors.green,
    'cancelled': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isAdmin = user?.role.toString() == 'UserRole.admin';
    final ordersAsync = ref.watch(
      ordersProvider(_selectedFilter == 'all' ? null : _selectedFilter),
    );

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(isAdmin ? 'Gestión de Pedidos' : 'Mis Pedidos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(ordersProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de filtros horizontal para filtrar pedidos por estado
          Container(
            height: 60,
            color: Colors.grey[100],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: _statusLabels.length,
              itemBuilder: (context, index) {
                final status = _statusLabels.keys.elementAt(index);
                final label = _statusLabels[status]!;
                final isSelected = _selectedFilter == status;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      // Actualizar filtro seleccionado
                      setState(() => _selectedFilter = status);
                    },
                    selectedColor: Colors.deepPurple.withOpacity(0.2),
                    checkmarkColor: Colors.deepPurple,
                  ),
                );
              },
            ),
          ),

          // Lista de pedidos
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay pedidos ${_selectedFilter != 'all' ? _statusLabels[_selectedFilter]!.toLowerCase() : ''}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(ordersProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _OrderCard(
                        order: order,
                        isAdmin: isAdmin,
                        statusColors: _statusColors,
                        statusLabels: _statusLabels,
                        onStatusChanged: () {
                          ref.invalidate(ordersProvider);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(ordersProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final bool isAdmin;
  final Map<String, Color> statusColors;
  final Map<String, String> statusLabels;
  final VoidCallback onStatusChanged;

  const _OrderCard({
    required this.order,
    required this.isAdmin,
    required this.statusColors,
    required this.statusLabels,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'pending';
    final statusColor = statusColors[status] ?? Colors.grey;
    final total = order['total'] ?? 0;
    final items = order['items'] as List? ?? [];
    final createdAt = order['createdAt'] ?? '';
    final userName = order['userName'] ?? 'Cliente';
    final userEmail = order['userEmail'] ?? '';
    final orderNumber = order['orderNumber'] ?? order['id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.receipt, color: statusColor),
        ),
        title: Text(
          'Pedido #$orderNumber',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (isAdmin)
              Text(
                'Cliente: $userName',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            if (isAdmin && userEmail.isNotEmpty)
              Text(
                userEmail,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            const SizedBox(height: 2),
            Text(
              'Total: \$${total.toStringAsFixed(0)} COP',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            statusLabels[status] ?? status,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: statusColor,
        ),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del cliente (solo para admin)
                if (isAdmin) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cliente: $userName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (userEmail.isNotEmpty)
                                Text(
                                  userEmail,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Items del pedido
                const Text(
                  'Productos:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['quantity']}x ${item['productName'] ?? 'Producto'}',
                          ),
                        ),
                        Text(
                          '\$${(item['productPrice'] ?? item['price'] ?? 0).toStringAsFixed(0)} COP',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL DEL PEDIDO:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(0)} COP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                // Botones de cambio de estado (solo para admin)
                if (isAdmin) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Cambiar Estado:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (status == 'pending')
                        _StatusButton(
                          label: 'Iniciar Proceso',
                          icon: Icons.play_arrow,
                          color: Colors.blue,
                          onPressed: () => _changeStatus(
                            context,
                            order['id'].toString(),
                            'processing',
                          ),
                        ),
                      if (status == 'processing')
                        _StatusButton(
                          label: 'Marcar Enviado',
                          icon: Icons.local_shipping,
                          color: Colors.purple,
                          onPressed: () => _changeStatus(
                            context,
                            order['id'].toString(),
                            'shipped',
                          ),
                        ),
                      if (status == 'shipped')
                        _StatusButton(
                          label: 'Marcar Entregado',
                          icon: Icons.check_circle,
                          color: Colors.green,
                          onPressed: () => _changeStatus(
                            context,
                            order['id'].toString(),
                            'delivered',
                          ),
                        ),
                      if (status != 'cancelled' && status != 'delivered')
                        _StatusButton(
                          label: 'Cancelar',
                          icon: Icons.cancel,
                          color: Colors.red,
                          onPressed: () => _changeStatus(
                            context,
                            order['id'].toString(),
                            'cancelled',
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeStatus(
    BuildContext context,
    String orderId,
    String newStatus,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Cambio'),
        content: Text('¿Cambiar estado a "${statusLabels[newStatus]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: statusColors[newStatus],
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final apiService = ApiService();
        final orderService = OrderService(apiService);

        await orderService.updateOrderStatus(orderId, newStatus);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Estado actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          onStatusChanged();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
