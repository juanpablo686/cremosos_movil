import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/purchase.dart';
import '../../models/supplier.dart';
import '../../models/product.dart';
import '../../services/purchases_service.dart';
import '../../services/suppliers_service.dart';
import '../../providers/products_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class PurchasesManagementScreen extends ConsumerStatefulWidget {
  const PurchasesManagementScreen({super.key});

  @override
  ConsumerState<PurchasesManagementScreen> createState() =>
      _PurchasesManagementScreenState();
}

class _PurchasesManagementScreenState
    extends ConsumerState<PurchasesManagementScreen> {
  bool _isLoading = false;
  List<Purchase> _purchases = [];

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      final purchasesService = PurchasesService(apiService);
      final purchases = await purchasesService.getPurchases();
      setState(() {
        _purchases = purchases;
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
    final totalPurchases = _purchases.length;
    final monthTotal = _purchases.fold<double>(0, (sum, p) => sum + p.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Compras'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPurchases,
          ),
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
                          'Total Compras',
                          '$totalPurchases',
                          Icons.shopping_cart,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total Gastado',
                          '\$${NumberFormat('#,###').format(monthTotal)}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Lista de compras
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
                                  'Historial de Compras',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _showNewPurchaseDialog(),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Nueva Compra'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _purchases.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            size: 64,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No hay compras registradas',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Haz clic en "Nueva Compra" para registrar una',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _purchases.length,
                                      itemBuilder: (context, index) {
                                        final purchase = _purchases[index];
                                        return Card(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: _getStatusColor(
                                                purchase.status,
                                              ),
                                              child: Icon(
                                                _getStatusIcon(purchase.status),
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(
                                              '${purchase.purchaseNumber} - ${purchase.supplierName}',
                                            ),
                                            subtitle: Text(
                                              '${purchase.items.length} items • ${_formatDate(purchase.createdAt)}\n${purchase.statusDisplay}',
                                            ),
                                            isThreeLine: true,
                                            trailing: Text(
                                              '\$${NumberFormat('#,###').format(purchase.total)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            onTap: () =>
                                                _showPurchaseDetail(purchase),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
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

  void _showPurchaseDetail(Purchase purchase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Compra ${purchase.purchaseNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Proveedor:', purchase.supplierName),
              _buildDetailRow('Estado:', purchase.statusDisplay),
              _buildDetailRow('Fecha:', _formatDate(purchase.createdAt)),
              const Divider(height: 24),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...purchase.items.map(
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
                '\$${NumberFormat('#,###').format(purchase.subtotal)}',
              ),
              _buildDetailRow(
                'IVA:',
                '\$${NumberFormat('#,###').format(purchase.tax)}',
              ),
              _buildDetailRow(
                'Total:',
                '\$${NumberFormat('#,###').format(purchase.total)}',
                isTotal: true,
              ),
              if (purchase.notes != null) ...[
                const Divider(height: 24),
                const Text(
                  'Notas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(purchase.notes!),
              ],
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
              color: isTotal ? Colors.indigo : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewPurchaseDialog() async {
    // Cargar proveedores y productos
    final apiService = ref.read(apiServiceProvider);
    final suppliersService = SuppliersService(apiService);
    final suppliers = await suppliersService.getSuppliers();
    final productsState = ref.read(productsProvider);
    final products = productsState.allProducts;

    if (suppliers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay proveedores registrados')),
      );
      return;
    }

    Supplier? selectedSupplier;
    final purchaseItems = <Map<String, dynamic>>[];
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Nueva Compra'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<Supplier>(
                      decoration: const InputDecoration(labelText: 'Proveedor'),
                      value: selectedSupplier,
                      items: suppliers
                          .map(
                            (s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedSupplier = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Items de compra:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (ctx) =>
                              _AddPurchaseItemDialog(products: products),
                        );
                        if (result != null) {
                          setDialogState(() => purchaseItems.add(result));
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Item'),
                    ),
                    const SizedBox(height: 8),
                    ...purchaseItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      final product = products.firstWhere(
                        (p) => p.id == item['productId'],
                      );
                      return Card(
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                            'Cantidad: ${item['quantity']} • Precio: \$${item['unitPrice']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setDialogState(() => purchaseItems.removeAt(idx));
                            },
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: selectedSupplier != null && purchaseItems.isNotEmpty
                    ? () async {
                        try {
                          final purchasesService = PurchasesService(apiService);
                          await purchasesService.createPurchase(
                            supplierId: selectedSupplier!.id,
                            items: purchaseItems,
                            notes: notesController.text.isNotEmpty
                                ? notesController.text
                                : null,
                          );
                          Navigator.pop(context);
                          _loadPurchases();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Compra registrada exitosamente'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    : null,
                child: const Text('Registrar Compra'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AddPurchaseItemDialog extends StatefulWidget {
  final List<Product> products;

  const _AddPurchaseItemDialog({required this.products});

  @override
  State<_AddPurchaseItemDialog> createState() => _AddPurchaseItemDialogState();
}

class _AddPurchaseItemDialogState extends State<_AddPurchaseItemDialog> {
  Product? selectedProduct;
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Product>(
            decoration: const InputDecoration(labelText: 'Producto'),
            value: selectedProduct,
            items: widget.products
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedProduct = value;
                priceController.text = value?.price.toString() ?? '';
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Cantidad'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Precio Unitario'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed:
              selectedProduct != null &&
                  quantityController.text.isNotEmpty &&
                  priceController.text.isNotEmpty
              ? () {
                  Navigator.pop(context, {
                    'productId': selectedProduct!.id,
                    'quantity': int.parse(quantityController.text),
                    'unitPrice': double.parse(priceController.text),
                  });
                }
              : null,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
