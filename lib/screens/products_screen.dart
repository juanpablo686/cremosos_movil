// screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: () {
              ref.read(productsProvider.notifier).clearFilters();
              _searchController.clear();
            },
            tooltip: 'Limpiar filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(productsProvider.notifier).search('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) =>
                  ref.read(productsProvider.notifier).search(value),
            ),
          ),

          // Category Filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  label: 'Todos',
                  selected: productsState.selectedCategory == null,
                  onSelected: () => ref
                      .read(productsProvider.notifier)
                      .filterByCategory(null),
                ),
                ...ProductCategory.values.map((category) {
                  final label = switch (category) {
                    ProductCategory.arrozConLeche => 'Arroz',
                    ProductCategory.fresasConCrema => 'Fresas',
                    ProductCategory.postresEspeciales => 'Postres Esp.',
                    ProductCategory.bebidasCremosas => 'Bebidas Crem.',
                    ProductCategory.toppings => 'Toppings',
                    ProductCategory.bebidas => 'Bebidas',
                    ProductCategory.postres => 'Postres',
                  };
                  return _CategoryChip(
                    label: label,
                    selected: productsState.selectedCategory == category,
                    onSelected: () => ref
                        .read(productsProvider.notifier)
                        .filterByCategory(category),
                  );
                }),
              ],
            ),
          ),

          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Ordenar:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ProductSortOption>(
                    value: productsState.sortOption,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    items: ProductSortOption.values.map((option) {
                      final label = switch (option) {
                        ProductSortOption.nameAsc => 'Nombre A-Z',
                        ProductSortOption.nameDesc => 'Nombre Z-A',
                        ProductSortOption.priceAsc => 'Precio: Menor',
                        ProductSortOption.priceDesc => 'Precio: Mayor',
                        ProductSortOption.ratingDesc => 'Mejor valorados',
                        ProductSortOption.newest => 'Más nuevos',
                        ProductSortOption.popularity => 'Más populares',
                      };
                      return DropdownMenuItem(
                          value: option,
                          child: Text(label,
                              style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null)
                        ref.read(productsProvider.notifier).sortBy(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${productsState.filteredProducts.length} productos encontrados',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),

          // Products Grid
          Expanded(
            child: productsState.currentPageProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text('No se encontraron productos'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: productsState.currentPageProducts.length,
                    itemBuilder: (context, index) {
                      final product = productsState.currentPageProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),

          // Pagination
          if (productsState.totalPages > 1)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: productsState.currentPage > 1
                        ? () => ref
                            .read(productsProvider.notifier)
                            .goToPage(productsState.currentPage - 1)
                        : null,
                  ),
                  Text(
                      'Página ${productsState.currentPage} de ${productsState.totalPages}'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        productsState.currentPage < productsState.totalPages
                            ? () => ref
                                .read(productsProvider.notifier)
                                .goToPage(productsState.currentPage + 1)
                            : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _CategoryChip(
      {required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product)),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image,
                              size: 32, color: Colors.grey.shade400),
                          const SizedBox(height: 4),
                          Text('Sin imagen',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ),
                ),
                if (product.onSale == true)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('OFERTA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 10, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: const TextStyle(fontSize: 9)),
                    ],
                  ),
                  const Spacer(),
                  if (product.salePrice != null) ...[
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 8,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${product.effectivePrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  ] else
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
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
