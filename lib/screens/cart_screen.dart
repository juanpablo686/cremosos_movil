// screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import '../models/cart.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final itemsWithDetails = ref.watch(cartItemsWithDetailsProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Vaciar carrito'),
                    content:
                        const Text('¿Seguro que deseas vaciar el carrito?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar')),
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clear();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Vaciar',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: cartState.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Continuar comprando'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: itemsWithDetails.length,
                    itemBuilder: (context, index) {
                      final itemData = itemsWithDetails[index];
                      final cartItem = itemData['item'] as CartItem;
                      final product = itemData['product'] as Product;
                      final toppings = itemData['toppings'] as List<Product>;
                      final toppingsTotal =
                          toppings.fold<double>(0, (sum, t) => sum + t.price);
                      final itemTotal =
                          (product.effectivePrice + toppingsTotal) *
                              cartItem.quantity;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.effectivePrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (toppings.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Toppings: ${toppings.map((t) => t.name).join(", ")}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        '+\$${toppingsTotal.toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () => ref
                                                    .read(cartProvider.notifier)
                                                    .updateQuantity(
                                                      cartItem.productId,
                                                      cartItem.quantity - 1,
                                                      toppings: cartItem
                                                          .selectedToppings,
                                                    ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(Icons.remove,
                                                      size: 18),
                                                ),
                                              ),
                                              Text('${cartItem.quantity}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              InkWell(
                                                onTap: () => ref
                                                    .read(cartProvider.notifier)
                                                    .updateQuantity(
                                                      cartItem.productId,
                                                      cartItem.quantity + 1,
                                                      toppings: cartItem
                                                          .selectedToppings,
                                                    ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child:
                                                      Icon(Icons.add, size: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${itemTotal.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () =>
                                    ref.read(cartProvider.notifier).removeItem(
                                          cartItem.productId,
                                          toppings: cartItem.selectedToppings,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Coupon Input
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                decoration: InputDecoration(
                                  labelText: 'Código de cupón',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  isDense: true,
                                  suffixIcon: cartState.couponCode != null
                                      ? IconButton(
                                          icon:
                                              const Icon(Icons.close, size: 18),
                                          onPressed: () {
                                            ref
                                                .read(cartProvider.notifier)
                                                .removeCoupon();
                                            _couponController.clear();
                                          },
                                        )
                                      : null,
                                ),
                                enabled: cartState.couponCode == null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: cartState.couponCode == null
                                  ? () {
                                      final code =
                                          _couponController.text.trim();
                                      if (code.isNotEmpty) {
                                        ref
                                            .read(cartProvider.notifier)
                                            .applyCoupon(code);
                                        // Wait a frame to check if coupon was applied
                                        Future.delayed(Duration.zero, () {
                                          final newState =
                                              ref.read(cartProvider);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  newState.couponCode != null
                                                      ? 'Cupón aplicado'
                                                      : 'Cupón inválido'),
                                              backgroundColor:
                                                  newState.couponCode != null
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          );
                                        });
                                      }
                                    }
                                  : null,
                              child: const Text('Aplicar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Price Breakdown
                        _PriceRow(label: 'Subtotal', value: cartState.subtotal),
                        if (cartState.discount > 0) ...[
                          _PriceRow(
                            label: 'Descuento (${cartState.couponCode})',
                            value: -cartState.discount,
                            valueColor: Colors.green,
                          ),
                        ],
                        _PriceRow(
                            label: 'Impuesto (16%)', value: cartState.tax),
                        _PriceRow(
                            label: 'Envío',
                            value: cartState.shipping,
                            valueColor:
                                cartState.shipping == 0 ? Colors.green : null),
                        const Divider(thickness: 2),
                        _PriceRow(
                          label: 'Total',
                          value: cartState.total,
                          isTotal: true,
                        ),
                        const SizedBox(height: 16),

                        // Checkout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (!isAuthenticated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Inicia sesión para continuar')),
                                );
                                return;
                              }
                              _showCheckoutDialog(context, ref, cartState);
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text('PROCEDER AL PAGO'),
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)),
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

  void _showCheckoutDialog(
      BuildContext context, WidgetRef ref, Cart cartState) {
    final user = ref.read(currentUserProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar pedido'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen del pedido:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _PriceRow(label: 'Subtotal', value: cartState.subtotal),
              if (cartState.discount > 0)
                _PriceRow(
                  label: 'Descuento',
                  value: -cartState.discount,
                  valueColor: Colors.green,
                ),
              _PriceRow(label: 'Impuesto (16%)', value: cartState.tax),
              _PriceRow(label: 'Envío', value: cartState.shipping),
              const Divider(),
              _PriceRow(
                label: 'Total a pagar',
                value: cartState.total,
                isTotal: true,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Entregar a:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(user?.name ?? 'Usuario'),
              Text(user?.email ?? ''),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recibirás un correo de confirmación con los detalles de tu pedido.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _processOrder(context, ref, cartState);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Confirmar pedido'),
          ),
        ],
      ),
    );
  }

  void _processOrder(BuildContext context, WidgetRef ref, Cart cartState) {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Procesando tu pedido...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simular procesamiento
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Cerrar loading

      // Limpiar carrito
      ref.read(cartProvider.notifier).clear();

      // Mostrar éxito
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 32),
              const SizedBox(width: 12),
              const Text('¡Pedido exitoso!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu pedido ha sido procesado correctamente.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Número de orden:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '#${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total pagado:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '\$${cartState.total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recibirás un correo de confirmación con los detalles de tu pedido y el tiempo estimado de entrega.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Volver a home
              },
              child: const Text('Continuar comprando'),
            ),
          ],
        ),
      );
    });
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int value;
  final bool isTotal;
  final Color? valueColor;

  const _PriceRow(
      {required this.label,
      required this.value,
      this.isTotal = false,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? (isTotal ? Colors.deepPurple : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
