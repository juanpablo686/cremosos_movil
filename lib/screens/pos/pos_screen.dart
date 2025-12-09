// screens/pos/pos_screen.dart - Punto de Venta

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../services/product_service.dart';
import '../../services/sales_service.dart';
import '../../services/users_service.dart';
import '../../providers/products_provider_api.dart' as products_api;

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  List<Product> products = [];
  List<User> customers = []; // Lista de clientes
  User? selectedCustomer; // Cliente seleccionado
  Map<String, int> cart = {}; // productId -> quantity
  bool isLoading = true;
  String paymentMethod = 'cash';
  double discount = 0;
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCustomers();
  }

  Future<void> _loadProducts() async {
    setState(() => isLoading = true);

    try {
      final apiService = ref.read(products_api.apiServiceProvider);
      final productService = ProductService(apiService);

      final productsData = await productService.getAllProducts();

      setState(() {
        products = productsData.map((p) {
          // Convertir datos del servidor a modelo Product
          return Product.fromJson(p);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar productos: $e')),
        );
      }
    }
  }

  Future<void> _loadCustomers() async {
    try {
      final apiService = ref.read(products_api.apiServiceProvider);
      final usersService = UsersService(apiService);

      final result = await usersService.getUsers(role: 'customer');

      setState(() {
        // Extraer la lista de usuarios del resultado
        customers = (result['users'] as List<User>);
      });
    } catch (e) {
      print('Error al cargar clientes: $e');
      // No mostrar error, solo log
    }
  }

  void _selectCustomer(User? customer) {
    setState(() {
      selectedCustomer = customer;
      if (customer != null) {
        customerNameController.text = customer.name;
        customerPhoneController.text = customer.phone ?? '';
        customerEmailController.text = customer.email;
      } else {
        customerNameController.clear();
        customerPhoneController.clear();
        customerEmailController.clear();
      }
    });
  }

  void _addToCart(Product product) {
    setState(() {
      cart[product.id] = (cart[product.id] ?? 0) + 1;
      print('=== PRODUCTO AGREGADO AL CARRITO ===');
      print('Producto: ${product.name}');
      print('ID: ${product.id}');
      print('Cantidad en carrito: ${cart[product.id]}');
      print('Total items en carrito: ${cart.length}');
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      if (cart[productId] != null && cart[productId]! > 1) {
        cart[productId] = cart[productId]! - 1;
      } else {
        cart.remove(productId);
      }
    });
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    cart.forEach((productId, quantity) {
      final product = products.firstWhere((p) => p.id == productId);
      subtotal += product.price * quantity;
    });
    return subtotal;
  }

  double _calculateTotal() {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * 0.08;
    return subtotal + tax - discount;
  }

  Future<void> _completeSale() async {
    print('=== DEBUG COMPLETAR VENTA ===');
    print('Cart isEmpty: ${cart.isEmpty}');
    print('Cart length: ${cart.length}');
    print('Cart contents: $cart');

    if (cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El carrito está vacío')));
      return;
    }

    try {
      final apiService = ref.read(products_api.apiServiceProvider);
      final salesService = SalesService(apiService);

      // Preparar items de la venta
      final items = cart.entries.map((entry) {
        final product = products.firstWhere((p) => p.id == entry.key);
        return {
          'productId': product.id,
          'productName': product.name,
          'quantity': entry.value,
          'unitPrice': product.price,
          'total': product.price * entry.value,
        };
      }).toList();

      // Crear venta
      await salesService.createSale(
        items: items,
        paymentMethod: paymentMethod,
        discount: discount,
        customerName: customerNameController.text.isEmpty
            ? null
            : customerNameController.text,
        customerPhone: customerPhoneController.text.isEmpty
            ? null
            : customerPhoneController.text,
      );

      if (mounted) {
        // Limpiar carrito y datos del cliente
        setState(() {
          cart.clear();
          discount = 0;
          selectedCustomer = null;
          customerNameController.clear();
          customerPhoneController.clear();
          customerEmailController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Venta completada exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Recargar productos para actualizar stock
        await _loadProducts();
        
        // NO hacer pop, quedarse en POS para seguir vendiendo
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al completar venta: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * 0.08;
    final total = _calculateTotal();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Punto de Venta'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProducts,
            ),
          ],
        ),
        body: Row(
          children: [
            // Lista de productos
            Expanded(
              flex: 2,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: InkWell(
                            onTap: () => _addToCart(product),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stock: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product.stock > 10
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Carrito y checkout
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue,
                      width: double.infinity,
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${cart.length} items',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: cart.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Carrito vacío',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Haz clic en un producto\npara agregarlo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              children: cart.entries.map((entry) {
                                final product = products.firstWhere(
                                  (p) => p.id == entry.key,
                                );
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(
                                    '\$${product.price.toStringAsFixed(0)} x ${entry.value}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () =>
                                            _removeFromCart(entry.key),
                                      ),
                                      Text('${entry.value}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => _addToCart(product),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Selector de cliente
                          DropdownButtonFormField<User?>(
                            value: selectedCustomer,
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar Cliente',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            hint: const Text('Cliente no registrado'),
                            items: [
                              const DropdownMenuItem<User?>(
                                value: null,
                                child: Text('Cliente no registrado'),
                              ),
                              ...customers.map((customer) {
                                return DropdownMenuItem<User?>(
                                  value: customer,
                                  child: Text(
                                    '${customer.name} - ${customer.email}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: _selectCustomer,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: customerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del cliente',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            readOnly: selectedCustomer != null,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: customerPhoneController,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            readOnly: selectedCustomer != null,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: customerEmailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            readOnly: selectedCustomer != null,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: paymentMethod,
                            decoration: const InputDecoration(
                              labelText: 'Método de pago',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'cash',
                                child: Text('Efectivo'),
                              ),
                              DropdownMenuItem(
                                value: 'card',
                                child: Text('Tarjeta'),
                              ),
                              DropdownMenuItem(
                                value: 'transfer',
                                child: Text('Transferencia'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => paymentMethod = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal:'),
                              Text('\$${subtotal.toStringAsFixed(0)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('IVA (8%):'),
                              Text('\$${tax.toStringAsFixed(0)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Descuento:'),
                              Text('\$${discount.toStringAsFixed(0)}'),
                            ],
                          ),
                          const Divider(),
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
                                '\$${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: cart.isEmpty ? null : _completeSale,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                'COMPLETAR VENTA',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
