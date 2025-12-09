// providers/products_provider.dart - Provider de Productos

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../data/products_data.dart';
import 'auth_provider.dart';

// Estado de productos
class ProductsState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final ProductCategory? selectedCategory;
  final String searchQuery;
  final ProductSortOption sortOption;
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final int currentPage;
  final int itemsPerPage;
  final bool isLoading;

  ProductsState({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategory,
    this.searchQuery = '',
    this.sortOption = ProductSortOption.nameAsc,
    this.minPrice = 0,
    this.maxPrice = double.infinity,
    this.minRating = 0,
    this.currentPage = 1,
    this.itemsPerPage = 20,
    this.isLoading = false,
  });

  ProductsState copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    ProductCategory? selectedCategory,
    String? searchQuery,
    ProductSortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? currentPage,
    int? itemsPerPage,
    bool? isLoading,
  }) {
    return ProductsState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalPages => (filteredProducts.length / itemsPerPage).ceil();

  List<Product> get currentPageProducts {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }
}

enum ProductSortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  ratingDesc,
  newest,
  popularity,
}

// Notificador de productos
class ProductsNotifier extends StateNotifier<ProductsState> {
  final Ref ref;

  ProductsNotifier(this.ref)
    : super(ProductsState(allProducts: [], filteredProducts: [])) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      // Cargar productos desde el backend
      final apiService = ref.read(apiServiceProvider);
      final productService = ProductService(apiService);
      final productsData = await productService.getAllProducts();

      // Convertir los datos del backend a objetos Product
      final products = productsData
          .map((json) => Product.fromJson(json))
          .toList();

      state = state.copyWith(
        allProducts: products,
        filteredProducts: products,
        isLoading: false,
      );

      // Aplicar filtros actuales
      _applyFilters();
    } catch (e) {
      print('Error cargando productos desde backend: $e');
      print('Usando datos mock como fallback...');
      // Si falla el backend, usar datos mock como fallback
      state = state.copyWith(
        allProducts: allProductsComplete,
        filteredProducts: allProductsComplete,
        isLoading: false,
      );
      _applyFilters();
    }
  }

  // Método público para refrescar productos
  Future<void> refresh() async {
    await _loadProducts();
  }

  // Filtrar por categoría con simulación asíncrona
  Future<void> filterByCategory(ProductCategory? category) async {
    state = state.copyWith(
      isLoading: true,
      selectedCategory: category,
      currentPage: 1,
    );

    // Simular delay
    await Future.delayed(const Duration(milliseconds: 300));

    _applyFilters();
    state = state.copyWith(isLoading: false);
  }

  // Buscar productos con simulación asíncrona
  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query, currentPage: 1);

    // Simular delay de búsqueda
    await Future.delayed(const Duration(milliseconds: 400));

    _applyFilters();
    state = state.copyWith(isLoading: false);
  }

  // Ordenar productos con simulación asíncrona
  Future<void> sortBy(ProductSortOption option) async {
    state = state.copyWith(isLoading: true, sortOption: option, currentPage: 1);

    // Simular delay
    await Future.delayed(const Duration(milliseconds: 200));

    _applyFilters();
    state = state.copyWith(isLoading: false);
  }

  // Filtrar por precio
  void filterByPrice(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max, currentPage: 1);
    _applyFilters();
  }

  // Filtrar por rating
  void filterByRating(double minRating) {
    state = state.copyWith(minRating: minRating, currentPage: 1);
    _applyFilters();
  }

  // Cambiar página
  void goToPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  // Limpiar filtros
  void clearFilters() {
    state = ProductsState(
      allProducts: state.allProducts,
      filteredProducts: state.allProducts,
      itemsPerPage: state.itemsPerPage,
    );
    _applyFilters();
  }

  // Aplicar todos los filtros
  void _applyFilters() {
    List<Product> filtered = List.from(state.allProducts);

    // Filtrar por categoría
    if (state.selectedCategory != null) {
      filtered = filtered
          .where((p) => p.category == state.selectedCategory)
          .toList();
    }

    // Buscar por texto
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.ingredients.any((i) => i.toLowerCase().contains(query));
      }).toList();
    }

    // Filtrar por precio
    filtered = filtered
        .where(
          (p) =>
              p.effectivePrice >= state.minPrice &&
              p.effectivePrice <= state.maxPrice,
        )
        .toList();

    // Filtrar por rating
    filtered = filtered.where((p) => p.rating >= state.minRating).toList();

    // Ordenar
    switch (state.sortOption) {
      case ProductSortOption.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.nameDesc:
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case ProductSortOption.priceAsc:
        filtered.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case ProductSortOption.priceDesc:
        filtered.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case ProductSortOption.ratingDesc:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.newest:
        // Por ahora mantener orden original
        break;
      case ProductSortOption.popularity:
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    state = state.copyWith(filteredProducts: filtered);
  }
}

// Provider de productos
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    return ProductsNotifier(ref);
  },
);

// Provider de producto por ID
final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final state = ref.watch(productsProvider);
  try {
    return state.allProducts.firstWhere((p) => p.id == id);
  } catch (e) {
    return null;
  }
});

// Provider de productos destacados
final featuredProductsProvider = Provider<List<Product>>((ref) {
  final state = ref.watch(productsProvider);
  return state.allProducts.where((p) => p.featured == true).toList();
});

// Provider de productos en oferta
final onSaleProductsProvider = Provider<List<Product>>((ref) {
  final state = ref.watch(productsProvider);
  return state.allProducts.where((p) => p.onSale == true).toList();
});

// Provider de productos relacionados
final relatedProductsProvider = Provider.family<List<Product>, String>((
  ref,
  productId,
) {
  final state = ref.watch(productsProvider);
  final product = ref.watch(productByIdProvider(productId));
  if (product == null) return [];

  return state.allProducts
      .where((p) => p.category == product.category && p.id != productId)
      .take(4)
      .toList();
});

// Provider de reviews por producto (temporal - devuelve lista vacía, implementar cuando haya endpoint)
final productReviewsProvider = Provider.family<List<Review>, String>((
  ref,
  productId,
) {
  return [];
});
