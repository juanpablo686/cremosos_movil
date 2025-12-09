import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/sale.dart';
import '../../services/sales_service.dart';
import '../../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class SalesManagementScreen extends ConsumerStatefulWidget {
  const SalesManagementScreen({super.key});

  @override
  ConsumerState<SalesManagementScreen> createState() =>
      _SalesManagementScreenState();
}

class _SalesManagementScreenState extends ConsumerState<SalesManagementScreen> {
  bool _isLoading = false;
  List<Sale> _sales = [];
  String? _filterPaymentMethod;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      final salesService = SalesService(apiService);
      final sales = await salesService.getSales(
        paymentMethod: _filterPaymentMethod,
      );
      setState(() {
        _sales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todaySales = _sales.where((s) {
      final saleDate = DateTime.parse(s.createdAt);
      final today = DateTime.now();
      return saleDate.year == today.year &&
          saleDate.month == today.month &&
          saleDate.day == today.day;
    }).toList();

    final todayTotal = todaySales.fold<double>(0, (sum, s) => sum + s.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterPaymentMethod = value == 'all' ? null : value;
              });
              _loadSales();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Todos')),
              const PopupMenuItem(value: 'cash', child: Text('Efectivo')),
              const PopupMenuItem(value: 'card', child: Text('Tarjeta')),
              const PopupMenuItem(
                value: 'transfer',
                child: Text('Transferencia'),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSales),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Estadísticas rápidas
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Ventas Hoy',
                          '${todaySales.length}',
                          Icons.today,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total Hoy',
                          '\$${NumberFormat('#,###').format(todayTotal)}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Lista de ventas
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Ventas Recientes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_filterPaymentMethod != null)
                                  Chip(
                                    label: Text(
                                      _getPaymentMethodDisplay(
                                        _filterPaymentMethod!,
                                      ),
                                    ),
                                    onDeleted: () {
                                      setState(
                                        () => _filterPaymentMethod = null,
                                      );
                                      _loadSales();
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _sales.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.point_of_sale,
                                            size: 64,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No hay ventas registradas',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Las ventas del POS aparecerán aquí',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _sales.length,
                                      itemBuilder: (context, index) {
                                        final sale = _sales[index];
                                        return Card(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  _getPaymentMethodColor(
                                                    sale.paymentMethod,
                                                  ),
                                              child: Icon(
                                                _getPaymentMethodIcon(
                                                  sale.paymentMethod,
                                                ),
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(
                                              '${sale.saleNumber} - ${sale.employeeName}',
                                            ),
                                            subtitle: Text(
                                              '${sale.items.length} items • ${sale.paymentMethodDisplay}\n${_formatDate(sale.createdAt)}',
                                            ),
                                            isThreeLine: true,
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '\$${NumberFormat('#,###').format(sale.total)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                if (sale.customerName != null)
                                                  Text(
                                                    sale.customerName!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            onTap: () => _showSaleDetail(sale),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'cash':
        return Colors.green;
      case 'card':
        return Colors.blue;
      case 'transfer':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'cash':
        return Icons.attach_money;
      case 'card':
        return Icons.credit_card;
      case 'transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodDisplay(String method) {
    switch (method) {
      case 'cash':
        return 'Efectivo';
      case 'card':
        return 'Tarjeta';
      case 'transfer':
        return 'Transferencia';
      default:
        return method;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showSaleDetail(Sale sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Venta ${sale.saleNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Empleado:', sale.employeeName),
              _buildDetailRow('Método de Pago:', sale.paymentMethodDisplay),
              _buildDetailRow('Fecha:', _formatDate(sale.createdAt)),
              if (sale.customerName != null)
                _buildDetailRow('Cliente:', sale.customerName!),
              if (sale.customerPhone != null)
                _buildDetailRow('Teléfono:', sale.customerPhone!),
              const Divider(height: 24),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...sale.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${item.productName} x${item.quantity}'),
                      ),
                      Text(
                        '\$${NumberFormat('#,###').format(item.total)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Subtotal:',
                '\$${NumberFormat('#,###').format(sale.subtotal)}',
              ),
              if (sale.discount > 0)
                _buildDetailRow(
                  'Descuento:',
                  '-\$${NumberFormat('#,###').format(sale.discount)}',
                ),
              _buildDetailRow(
                'IVA:',
                '\$${NumberFormat('#,###').format(sale.tax)}',
              ),
              _buildDetailRow(
                'Total:',
                '\$${NumberFormat('#,###').format(sale.total)}',
                isTotal: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
