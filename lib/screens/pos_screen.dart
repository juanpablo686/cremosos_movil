// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_drawer.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';

// Pantalla de Punto de Venta (POS - Point of Sale)
// EXPLICAR: Esta pantalla permite a empleados y admins procesar ventas rápidas
// sin necesidad de crear un usuario/cliente en el sistema
class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  List<dynamic> products = []; // Lista de productos disponibles
  List<Map<String, dynamic>> cartItems = []; // Carrito temporal del POS
  bool isLoading = true; // Estado de carga
  String? errorMessage; // Mensajes de error
  String searchQuery = ''; // Búsqueda de productos
  String selectedCategory = 'Todos'; // Filtro por categoría

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Cargar productos al iniciar la pantalla
  }

  // Cargar lista de productos desde la API
  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);
      final data = await productService.getAllProducts();

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar productos: $e';
        isLoading = false;
      });
    }
  }

  // Obtener lista de categorías únicas de los productos
  List<String> get categories {
    final cats = products
        .map((p) => p['category']?.toString() ?? 'Sin categoría')
        .toSet()
        .toList();
    cats.insert(0, 'Todos'); // Opción para mostrar todas las categorías
    return cats;
  }

  // Filtrar productos según búsqueda y categoría seleccionada
  // EXPLICAR: Solo muestra productos disponibles (isAvailable == true)
  List<dynamic> get filteredProducts {
    return products.where((p) {
      final matchesCategory =
          selectedCategory == 'Todos' || p['category'] == selectedCategory;
      final matchesSearch =
          searchQuery.isEmpty ||
          p['name']?.toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ==
              true;
      return matchesCategory && matchesSearch && (p['isAvailable'] == true);
    }).toList();
  }

  // Agregar producto al carrito del POS
  // Si ya existe, incrementa la cantidad
  void _addToCart(dynamic product) {
    setState(() {
      final existingIndex = cartItems.indexWhere(
        (item) => item['id'] == product['id'],
      );

      if (existingIndex >= 0) {
        cartItems[existingIndex]['quantity']++;
      } else {
        cartItems.add({
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'imageUrl': product['imageUrl'],
          'quantity': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} agregado'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  double get subtotal {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  double get tax {
    return subtotal * 0.08;
  }

  double get total {
    return subtotal + tax;
  }

  Future<void> _processSale() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Venta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subtotal: \$${subtotal.toStringAsFixed(0)} COP'),
            Text('IVA (8%): \$${tax.toStringAsFixed(0)} COP'),
            const Divider(),
            Text(
              'Total: \$${total.toStringAsFixed(0)} COP',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Mostrar indicador de carga
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final apiService = ApiService();
                final saleData = {
                  'items': cartItems
                      .map(
                        (item) => {
                          'id': item['id'],
                          'quantity': item['quantity'],
                        },
                      )
                      .toList(),
                  'paymentMethod': 'cash',
                  'customerName': 'Cliente General',
                };

                print('Enviando venta: $saleData'); // Debug

                final response = await apiService.post(
                  '/sales',
                  data: saleData,
                );

                // Cerrar indicador de carga
                if (context.mounted) Navigator.pop(context);

                print('Respuesta: ${response.statusCode}'); // Debug
                print('Data: ${response.data}'); // Debug

                if (response.statusCode == 201 || response.statusCode == 200) {
                  _clearCart();
                  await _loadProducts(); // Recargar productos para actualizar stock

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Venta procesada exitosamente!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  throw Exception(
                    'Error en la respuesta: ${response.statusCode}',
                  );
                }
              } catch (e) {
                // Cerrar indicador de carga si aún está abierto
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                print('Error procesando venta: $e'); // Debug

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al procesar venta: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProducts),
        ],
      ),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: category == selectedCategory,
                          onSelected: (selected) =>
                              setState(() => selectedCategory = category),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _ProductCard(
                              product: product,
                              onTap: () => _addToCart(product),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Carrito',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (cartItems.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          onPressed: _clearCart,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: cartItems.isEmpty
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
                                'Carrito vacío',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                                ),
                                title: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('\$${item['price']} COP'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () => _removeFromCart(index),
                                    ),
                                    Text(
                                      '${item['quantity']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () => _addToCart(item),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty)
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
                            const Text('Subtotal:'),
                            Text('\$${subtotal.toStringAsFixed(0)} COP'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('IVA (8%):'),
                            Text('\$${tax.toStringAsFixed(0)} COP'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(0)} COP',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _processSale,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Procesar Venta',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price']} COP',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product['stock']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
