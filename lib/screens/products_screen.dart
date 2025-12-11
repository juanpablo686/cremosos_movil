// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth_provider.dart';

// Pantalla de productos - muestra catálogo de productos disponibles
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar la pantalla
    Future.microtask(
      () => ref.read(productsListProvider.notifier).loadProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener lista de productos desde el provider
    final productsAsync = ref.watch(productsListProvider);
    final user = ref.watch(authProvider).user;
    // Verificar si el usuario es administrador para mostrar opciones de edición
    final isAdmin = user?.role.toString() == 'UserRole.admin';

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Botón de agregar producto solo visible para administradores
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showProductDialog(context),
            ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsListProvider);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductCard(product: product, isAdmin: isAdmin);
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
                onPressed: () => ref.invalidate(productsListProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context, [dynamic product]) {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(
      text: product?['price']?.toString() ?? '',
    );
    final descController = TextEditingController(
      text: product?['description'] ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product == null ? 'Crear Producto' : 'Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
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
            onPressed: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text);
              final desc = descController.text.trim();

              if (name.isEmpty || price == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa todos los campos')),
                );
                return;
              }

              try {
                final apiService = ApiService();
                final productService = ProductService(apiService);

                if (product == null) {
                  // Crear
                  await productService.createProduct(
                    name: name,
                    description: desc,
                    price: price,
                    category: 'otros',
                  );
                } else {
                  // Editar
                  await productService.updateProduct(
                    productId: product['id'].toString(),
                    name: name,
                    price: price,
                    description: desc,
                  );
                }

                if (ctx.mounted) Navigator.pop(ctx);
                ref.invalidate(productsListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        product == null
                            ? 'Producto creado exitosamente'
                            : 'Producto actualizado',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(product == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final dynamic product;
  final bool isAdmin;

  const _ProductCard({required this.product, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Image.network(
              product['imageUrl'] ??
                  'https://via.placeholder.com/150?text=Sin+Imagen',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 48),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Sin nombre',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '\$${(product['price'] ?? 0).toStringAsFixed(0)} COP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final apiService = ApiService();
                          await apiService.post(
                            '/cart/items',
                            data: {'productId': product['id'], 'quantity': 1},
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product['name']} agregado al carrito',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.shopping_cart, size: 16),
                      label: const Text(
                        'Agregar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Encontrar el padre _ProductsScreenState
                              final parentState = context
                                  .findAncestorStateOfType<
                                    _ProductsScreenState
                                  >();
                              if (parentState != null) {
                                parentState._showProductDialog(
                                  context,
                                  product,
                                );
                              }
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text(
                              'Editar',
                              style: TextStyle(fontSize: 11),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Eliminar'),
                                content: Text(
                                  '¿Eliminar "${product['name']}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              try {
                                final apiService = ApiService();
                                final productService = ProductService(
                                  apiService,
                                );
                                await productService.deleteProduct(
                                  product['id'].toString(),
                                );

                                ref.invalidate(productsListProvider);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Producto eliminado'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Provider simple para lista de productos
final productsListProvider =
    StateNotifierProvider<ProductsListNotifier, AsyncValue<List<dynamic>>>(
      (ref) => ProductsListNotifier(),
    );

class ProductsListNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  ProductsListNotifier() : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);
      // Solicitar todos los productos (limit=200 para asegurar que se obtengan todos)
      final data = await productService.getAllProducts(limit: 200);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
