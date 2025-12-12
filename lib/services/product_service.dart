import '../config/api_config.dart';
import 'api_service.dart';

/// Servicio de Productos
/// EXPLICAR EN EXPOSICIÓN: Maneja todas las operaciones relacionadas con
/// el catálogo de productos (listar, buscar, filtrar, obtener detalles)

class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService);

  /// GET ALL PRODUCTS - GET /api/products
  /// Obtener lista de todos los productos con filtros y paginación
  /// EXPLICAR: Los query parameters permiten filtrar y paginar resultados
  ///
  /// Ejemplo de URL: /api/products?category=arroz&page=1&limit=20&search=vainilla
  /// Response: { "products": [...], "total": 140, "page": 1, "pages": 7 }
  Future<List<dynamic>> getAllProducts({
    String? category, // Filtrar por categoría
    int? page, // Número de página (paginación)
    int? limit, // Cantidad de productos por página
    String? search, // Búsqueda por texto
    String? sortBy, // Ordenar por campo (price, name, rating)
    String? sortOrder, // Orden ascendente (asc) o descendente (desc)
  }) async {
    try {
      // Construir query parameters dinámicamente
      // EXPLICAR: Solo se envían los parámetros que tienen valor
      final queryParams = <String, dynamic>{};

      if (category != null) queryParams['category'] = category;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null) queryParams['search'] = search;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

      // Hacer petición GET con query parameters
      final response = await _apiService.get(
        ApiConfig.productsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Backend devuelve {success: true, data: [...], meta: {...}}
        return response.data['data'] ?? [];
      } else {
        throw Exception('Error al obtener productos');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET PRODUCT BY ID - GET /api/products/{id}
  /// Obtener detalle completo de un producto específico
  /// EXPLICAR: Usa el ID del producto en la URL (path parameter)
  ///
  /// Ejemplo: GET /api/products/123
  /// Response: { "id": 123, "name": "Arroz con Leche", "price": 18000, ... }
  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      // Construir URL con el ID del producto
      // EXPLICAR: ${ApiConfig.productDetailEndpoint}/$productId
      // Resultado: /api/products/123
      final response = await _apiService.get(
        '${ApiConfig.productDetailEndpoint}/$productId',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET FEATURED PRODUCTS - GET /api/products/featured
  /// Obtener productos destacados para mostrar en home
  /// EXPLICAR: Endpoint especial que retorna solo productos promocionados
  ///
  /// Response: { "products": [...] } (solo productos destacados)
  Future<List<dynamic>> getFeaturedProducts() async {
    try {
      final response = await _apiService.get(
        ApiConfig.featuredProductsEndpoint,
      );

      if (response.statusCode == 200) {
        // EXPLICAR: El servidor puede retornar directamente un array
        // o un objeto con la propiedad 'products'
        if (response.data is List) {
          return response.data;
        } else if (response.data is Map && response.data['products'] != null) {
          return response.data['products'];
        } else {
          return [];
        }
      } else {
        throw Exception('Error al obtener productos destacados');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// SEARCH PRODUCTS - GET /api/products?search={query}
  /// Buscar productos por nombre o descripción
  /// EXPLICAR: Usa el mismo endpoint de getAllProducts pero con parámetro search
  Future<List<dynamic>> searchProducts(String query) async {
    return getAllProducts(search: query);
  }

  /// GET PRODUCTS BY CATEGORY - GET /api/products?category={category}
  /// Filtrar productos por categoría específica
  /// EXPLICAR: Endpoint reutilizable con diferentes query parameters
  Future<List<dynamic>> getProductsByCategory(String category) async {
    return getAllProducts(category: category);
  }

  /// CREATE PRODUCT - POST /api/products
  /// Crear un nuevo producto (solo admin/employee)
  /// EXPLICAR: Envía datos del producto en el body de la petición
  Future<Map<String, dynamic>> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    String? imageUrl,
    int? stock,
    bool? isFeatured,
    List<String>? compatibleToppings,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.productsEndpoint,
        data: {
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          if (imageUrl != null) 'imageUrl': imageUrl,
          if (stock != null) 'stock': stock,
          if (isFeatured != null) 'isFeatured': isFeatured,
          if (compatibleToppings != null)
            'compatibleToppings': compatibleToppings,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Error al crear producto');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE PRODUCT - PUT /api/products/{id}
  /// Actualizar un producto existente (solo admin/employee)
  /// EXPLICAR: Usa método PUT y permite actualización parcial
  Future<Map<String, dynamic>> updateProduct({
    required String productId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    bool? isFeatured,
    bool? isAvailable,
    List<String>? compatibleToppings,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (price != null) data['price'] = price;
      if (imageUrl != null) data['imageUrl'] = imageUrl;
      if (category != null) data['category'] = category;
      if (stock != null) data['stock'] = stock;
      if (isFeatured != null) data['isFeatured'] = isFeatured;
      if (isAvailable != null) data['isAvailable'] = isAvailable;
      if (compatibleToppings != null)
        data['compatibleToppings'] = compatibleToppings;

      final response = await _apiService.put(
        '${ApiConfig.productDetailEndpoint}/$productId',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      } else {
        throw Exception(
          response.data['message'] ?? 'Error al actualizar producto',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE PRODUCT - DELETE /api/products/{id}
  /// Eliminar un producto (solo admin)
  /// EXPLICAR: Usa método DELETE para eliminar permanentemente
  Future<void> deleteProduct(String productId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConfig.productDetailEndpoint}/$productId',
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.data['message'] ?? 'Error al eliminar producto',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
