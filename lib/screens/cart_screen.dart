// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../widgets/app_drawer.dart';

// Pantalla del carrito de compras
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // Datos del carrito cargados desde el backend
  Map<String, dynamic>? cartData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Cargar datos del carrito desde la API
  Future<void> _loadCart() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = ApiService();
      // Obtener carrito del usuario autenticado
      final response = await apiService.get('/cart');

      if (response.statusCode == 200) {
        setState(() {
          // Extraer datos del carrito de la respuesta
          cartData = response.data['data'] ?? response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar carrito: $e';
        isLoading = false;
      });
    }
  }

  // Actualizar cantidad de un item en el carrito
  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    try {
      final apiService = ApiService();
      // Enviar nueva cantidad al backend
      await apiService.put(
        '/cart/items/$itemId',
        data: {'quantity': newQuantity},
      );

      // Recargar carrito para reflejar cambios
      await _loadCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cantidad actualizada'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Eliminar un producto del carrito
  Future<void> _removeItem(String itemId) async {
    try {
      final apiService = ApiService();
      // Llamar al endpoint de eliminación
      await apiService.delete('/cart/items/$itemId');

      await _loadCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto eliminado del carrito'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _createOrder() async {
    if (cartData == null || (cartData!['items'] as List).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear Pedido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Deseas crear un pedido con estos productos?'),
            const SizedBox(height: 16),
            Text(
              'Total: \$${_calculateTotal().toStringAsFixed(0)} COP',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar Pedido'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final apiService = ApiService();
        final response = await apiService.post(
          '/orders',
          data: {
            'shippingAddress': {
              'street': 'Calle 123',
              'city': 'Cali',
              'state': 'Valle del Cauca',
              'zipCode': '760001',
              'country': 'Colombia',
            },
            'paymentMethod': 'cash',
            'notes': 'Pedido desde app',
          },
        );

        if (response.statusCode == 201) {
          await _loadCart();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Pedido creado exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacementNamed(context, '/orders');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear pedido: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Calcular el total del carrito sumando precio * cantidad de cada item
  double _calculateTotal() {
    if (cartData == null) return 0;
    final items = cartData!['items'] as List? ?? [];
    return items.fold(0.0, (sum, item) {
      // Backend envía productPrice directamente en cada item
      final price = item['productPrice'] ?? 0;
      final quantity = item['quantity'] ?? 1;
      return sum + (price * quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCart),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCart,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : (cartData == null || (cartData!['items'] as List? ?? []).isEmpty)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega productos para continuar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: (cartData!['items'] as List).length,
                    itemBuilder: (context, index) {
                      final item = (cartData!['items'] as List)[index];
                      // Backend envía productPrice, productImage, productName directamente
                      final price = item['productPrice'] ?? 0;
                      final imageUrl = item['productImage'] ?? '';
                      final name = item['productName'] ?? 'Sin nombre';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.fastfood,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\$${price.toStringAsFixed(0)} COP c/u',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  final newQty = (item['quantity'] ?? 1) - 1;
                                  if (newQty > 0) {
                                    _updateQuantity(item['id'], newQty);
                                  } else {
                                    _removeItem(item['id']);
                                  }
                                },
                              ),
                              Text(
                                '${item['quantity'] ?? 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  _updateQuantity(
                                    item['id'],
                                    (item['quantity'] ?? 1) + 1,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeItem(item['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_calculateTotal().toStringAsFixed(0)} COP',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _createOrder,
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text(
                            'Crear Pedido',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
