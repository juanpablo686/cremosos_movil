/// Provider de Productos - VERSIÓN CON API REST
/// EXPLICAR EN EXPOSICIÓN: Gestión de estado de productos usando Riverpod + API
///
/// ANTES: Usábamos datos mock (allProducts lista estática)
/// AHORA: Consumimos API REST con ProductService

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_api.dart';
import '../models/api_response.dart';
import '../services/product_service.dart';
import '../services/api_service.dart';

/// EXPLICAR: Provider del servicio de productos
/// Singleton que se crea una sola vez y se reutiliza
final productServiceProvider = Provider<ProductService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductService(apiService);
});

/// EXPLICAR: Provider del servicio base de API
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Estado de Productos con Datos de API
/// EXPLICAR: Representa todos los posibles estados de la pantalla de productos
class ProductsState {
  /// Lista de productos cargados desde API
  final List<ProductApi> products;

  /// Estado de carga (initial, loading, success, error, empty)
  final DataState<List<ProductApi>> dataState;

  /// Filtros aplicados
  final ProductCategory? selectedCategory;
  final String searchQuery;
  final ProductSortOption sortOption;

  /// Paginación (controlada por el servidor)
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;

  ProductsState({
    this.products = const [],
    this.dataState = const DataStateInitial(),
    this.selectedCategory,
    this.searchQuery = '',
    this.sortOption = ProductSortOption.nameAsc,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.hasMore = false,
  });

  ProductsState copyWith({
    List<ProductApi>? products,
    DataState<List<ProductApi>>? dataState,
    ProductCategory? selectedCategory,
    String? searchQuery,
    ProductSortOption? sortOption,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasMore,
  }) {
    return ProductsState(
      products: products ?? this.products,
      dataState: dataState ?? this.dataState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Helpers para la UI
  bool get isLoading => dataState.isLoading;
  bool get hasError => dataState.isError;
  bool get isEmpty => dataState.isEmpty;
  String? get errorMessage => dataState.errorOrNull;
}

/// Opciones de Ordenamiento
enum ProductSortOption {
  nameAsc, // Nombre A-Z
  nameDesc, // Nombre Z-A
  priceAsc, // Precio menor a mayor
  priceDesc, // Precio mayor a menor
  ratingDesc, // Mejor calificados
  newest; // Más recientes

  /// EXPLICAR: Convertir a formato que espera el servidor
  String toApiParam() {
    switch (this) {
      case ProductSortOption.nameAsc:
        return 'name';
      case ProductSortOption.nameDesc:
        return 'name';
      case ProductSortOption.priceAsc:
        return 'price';
      case ProductSortOption.priceDesc:
        return 'price';
      case ProductSortOption.ratingDesc:
        return 'rating';
      case ProductSortOption.newest:
        return 'createdAt';
    }
  }

  String getSortOrder() {
    switch (this) {
      case ProductSortOption.nameDesc:
      case ProductSortOption.priceDesc:
      case ProductSortOption.ratingDesc:
      case ProductSortOption.newest:
        return 'desc';
      default:
        return 'asc';
    }
  }
}

/// Notificador de Productos
/// EXPLICAR: Maneja la lógica de negocio y comunica con el ProductService
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductService _productService;

  ProductsNotifier(this._productService) : super(ProductsState()) {
    // Cargar productos al inicializar
    loadProducts();
  }

  /// CARGAR PRODUCTOS - GET /api/products
  /// EXPLICAR EN EXPOSICIÓN: Petición principal que obtiene productos del servidor
  Future<void> loadProducts({
    ProductCategory? category,
    String? searchQuery,
    ProductSortOption? sortOption,
    int page = 1,
  }) async {
    // PASO 1: Cambiar estado a "loading"
    // EXPLICAR: La UI mostrará un spinner
    state = state.copyWith(
      dataState: DataState.loading(),
      selectedCategory: category ?? state.selectedCategory,
      searchQuery: searchQuery ?? state.searchQuery,
      sortOption: sortOption ?? state.sortOption,
      currentPage: page,
    );

    try {
      // PASO 2: Llamar al servicio (hace HTTP GET)
      // EXPLICAR: Aquí se envía la petición real al servidor
      final products = await _productService.getAllProducts(
        category: state.selectedCategory?.toJson(),
        page: page,
        limit: 20,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        sortBy: state.sortOption.toApiParam(),
        sortOrder: state.sortOption.getSortOrder(),
      );

      // PASO 3: Convertir datos dinámicos a ProductApi
      final productList = products
          .map((p) => ProductApi.fromJson(p as Map<String, dynamic>))
          .toList();

      // EXPLICAR: Si no hay productos, mostrar estado "empty"
      if (productList.isEmpty) {
        state = state.copyWith(
          products: [],
          dataState: DataState.empty(),
          totalPages: 0,
          totalItems: 0,
          hasMore: false,
        );
        return;
      }

      // PASO 4: Actualizar estado con datos exitosos
      state = state.copyWith(
        products: productList,
        dataState: DataState.success(productList),
        totalPages: (productList.length / 20).ceil(),
        totalItems: productList.length,
        hasMore: productList.length >= 20,
      );
    } catch (e, stackTrace) {
      // PASO 5: Manejar errores (red, timeout, etc)
      // EXPLICAR: Cualquier error se convierte en estado error
      state = state.copyWith(
        dataState: DataState.error(
          'Error al cargar productos: ${e.toString()}',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// FILTRAR POR CATEGORÍA
  /// EXPLICAR: Recarga productos con filtro de categoría
  Future<void> filterByCategory(ProductCategory? category) async {
    await loadProducts(category: category, page: 1);
  }

  /// BUSCAR PRODUCTOS
  /// EXPLICAR: Búsqueda por texto (nombre, descripción)
  Future<void> search(String query) async {
    await loadProducts(searchQuery: query, page: 1);
  }

  /// ORDENAR PRODUCTOS
  /// EXPLICAR: Cambia el orden de los resultados
  Future<void> sortBy(ProductSortOption option) async {
    await loadProducts(sortOption: option, page: 1);
  }

  /// CAMBIAR PÁGINA
  /// EXPLICAR: Carga la siguiente/anterior página
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages) {
      await loadProducts(page: page);
    }
  }

  /// CARGAR MÁS PRODUCTOS (Infinite Scroll)
  /// EXPLICAR: Para scroll infinito, agrega productos a la lista actual
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    final nextPage = state.currentPage + 1;

    // No cambiar a loading completo, usar un loading parcial
    try {
      final products = await _productService.getAllProducts(
        category: state.selectedCategory?.toJson(),
        page: nextPage,
        limit: 20,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        sortBy: state.sortOption.toApiParam(),
        sortOrder: state.sortOption.getSortOrder(),
      );

      final newProducts = products
          .map((p) => ProductApi.fromJson(p as Map<String, dynamic>))
          .toList();

      if (newProducts.isNotEmpty) {
        // EXPLICAR: Agregar nuevos productos a los existentes
        final allProducts = [...state.products, ...newProducts];

        state = state.copyWith(
          products: allProducts,
          dataState: DataState.success(allProducts),
          currentPage: nextPage,
          hasMore: newProducts.length >= 20,
        );
      }
    } catch (e) {
      // Error al cargar más, no hacer nada
      print('Error loading more: $e');
    }
  }

  /// REFRESCAR (Pull to Refresh)
  /// EXPLICAR: Recarga desde la página 1
  Future<void> refresh() async {
    await loadProducts(page: 1);
  }

  /// LIMPIAR FILTROS
  /// EXPLICAR: Vuelve al estado inicial sin filtros
  Future<void> clearFilters() async {
    state = ProductsState();
    await loadProducts();
  }
}

/// PROVIDER PRINCIPAL DE PRODUCTOS
/// EXPLICAR EN EXPOSICIÓN: Este provider lo usamos en las pantallas
/// Gestiona automáticamente el estado y las peticiones API
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final productService = ref.watch(productServiceProvider);
    return ProductsNotifier(productService);
  },
);

/// PROVIDER DE PRODUCTO POR ID
/// EXPLICAR: Obtiene un producto específico
/// FutureProvider porque es asíncrono
final productByIdProvider = FutureProvider.family<ProductApi?, String>((
  ref,
  id,
) async {
  final productService = ref.watch(productServiceProvider);

  try {
    final productData = await productService.getProductById(id);
    return ProductApi.fromJson(productData);
  } catch (e) {
    return null;
  }
});

/// PROVIDER DE PRODUCTOS DESTACADOS
/// EXPLICAR: Productos marcados como featured en el servidor
final featuredProductsProvider = FutureProvider<List<ProductApi>>((ref) async {
  final productService = ref.watch(productServiceProvider);

  try {
    final products = await productService.getFeaturedProducts();
    return products
        .map((p) => ProductApi.fromJson(p as Map<String, dynamic>))
        .toList();
  } catch (e) {
    return [];
  }
});

/// PROVIDER DE PRODUCTOS RELACIONADOS
/// EXPLICAR: Productos de la misma categoría
final relatedProductsProvider = FutureProvider.family<List<ProductApi>, String>(
  (ref, productId) async {
    final productService = ref.watch(productServiceProvider);

    try {
      // Primero obtener el producto
      final productData = await productService.getProductById(productId);
      final product = ProductApi.fromJson(productData);

      // Luego obtener productos de la misma categoría
      final categoryProducts = await productService.getProductsByCategory(
        product.category.toJson(),
      );

      // Convertir y filtrar el producto actual
      final productList = categoryProducts
          .map((p) => ProductApi.fromJson(p as Map<String, dynamic>))
          .where((p) => p.id != productId)
          .take(4)
          .toList();

      return productList;
    } catch (e) {
      return [];
    }
  },
);

/// EJEMPLO DE USO EN UI:
/// 
/// ```dart
/// class ProductsScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final state = ref.watch(productsProvider);
///     
///     // EXPLICAR: Pattern matching para mostrar UI según estado
///     return state.dataState.when(
///       initial: () => Text('Presiona para cargar'),
///       
///       loading: () => Center(
///         child: CircularProgressIndicator(),
///       ),
///       
///       success: (products) => ListView.builder(
///         itemCount: products.length,
///         itemBuilder: (context, index) {
///           return ProductCard(product: products[index]);
///         },
///       ),
///       
///       error: (message) => Center(
///         child: Column(
///           children: [
///             Icon(Icons.error),
///             Text(message),
///             ElevatedButton(
///               onPressed: () => ref.read(productsProvider.notifier).refresh(),
///               child: Text('Reintentar'),
///             ),
///           ],
///         ),
///       ),
///       
///       empty: () => Center(
///         child: Text('No se encontraron productos'),
///       ),
///     );
///   }
/// }
/// ```
