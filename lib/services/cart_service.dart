// Importar configuración de la API y servicio base
import '../config/api_config.dart';
import 'api_service.dart';

/// Servicio de Carrito de Compras
/// EXPLICAR EN EXPOSICIÓN: Implementa las 4 operaciones CRUD completas:
/// - CREATE (POST): Agregar producto al carrito
/// - READ (GET): Obtener carrito actual del usuario
/// - UPDATE (PUT): Modificar cantidad de un producto
/// - DELETE: Eliminar producto del carrito o vaciar todo
/// IMPORTANTE: Cada usuario tiene su propio carrito que persiste en la base de datos
/// El servidor identifica al usuario mediante el token JWT

class CartService {
  // Referencia al servicio base de API para hacer peticiones HTTP
  final ApiService _apiService;

  // Inyección de dependencias en el constructor
  CartService(this._apiService);

  /// GET CART - GET /api/cart
  /// Obtener el carrito del usuario autenticado
  /// EXPLICAR: Requiere autenticación (token JWT)
  /// El servidor sabe qué carrito retornar basado en el token
  ///
  /// Response: {
  ///   "id": 1,
  ///   "userId": 123,
  ///   "items": [
  ///     {
  ///       "id": 1,
  ///       "productId": 456,
  ///       "product": {...},
  ///       "quantity": 2,
  ///       "toppings": [...],
  ///       "subtotal": 40000
  ///     }
  ///   ],
  ///   "subtotal": 40000,
  ///   "tax": 7600,
  ///   "total": 47600
  /// }
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _apiService.get(ApiConfig.cartEndpoint);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener carrito');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ADD ITEM TO CART - POST /api/cart/items
  /// Agregar un producto al carrito
  /// EXPLICAR: CREATE operation en CRUD
  ///
  /// Request body: {
  ///   "productId": "acl-001",
  ///   "quantity": 2,
  ///   "toppings": ["topping-001", "topping-002"]
  /// }
  /// Response: {
  ///   "message": "Producto agregado al carrito",
  ///   "cart": {...}  // Carrito actualizado
  /// }
  Future<Map<String, dynamic>> addItemToCart({
    required String productId,
    required int quantity,
    List<String>? toppingIds,
  }) async {
    try {
      final data = {
        'productId': productId,
        'quantity': quantity,
        if (toppingIds != null && toppingIds.isNotEmpty) 'toppings': toppingIds,
      };

      // POST crea un nuevo recurso (item en el carrito)
      final response = await _apiService.post(
        ApiConfig.cartItemsEndpoint,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al agregar producto al carrito');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE CART ITEM - PUT /api/cart/items/{itemId}
  /// Actualizar cantidad de un producto en el carrito
  /// EXPLICAR: UPDATE operation en CRUD
  /// PUT actualiza el recurso completo
  ///
  /// Request body: { "quantity": 3 }
  /// Response: {
  ///   "message": "Cantidad actualizada",
  ///   "item": {...},
  ///   "cart": {...}
  /// }
  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final data = {'quantity': quantity};

      // PUT para actualizar completamente el item
      final response = await _apiService.put(
        '${ApiConfig.cartItemsEndpoint}/$itemId',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al actualizar cantidad');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE CART ITEM - DELETE /api/cart/items/{itemId}
  /// Eliminar un producto del carrito
  /// EXPLICAR: DELETE operation en CRUD
  ///
  /// Response: {
  ///   "message": "Producto eliminado del carrito",
  ///   "cart": {...}  // Carrito actualizado
  /// }
  Future<Map<String, dynamic>> removeCartItem(String itemId) async {
    try {
      // DELETE elimina el recurso del servidor
      final response = await _apiService.delete(
        '${ApiConfig.cartItemsEndpoint}/$itemId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // 204 No Content es común en DELETE exitoso
        if (response.data != null) {
          return response.data;
        } else {
          return {'message': 'Producto eliminado'};
        }
      } else {
        throw Exception('Error al eliminar producto');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// CLEAR CART - DELETE /api/cart
  /// Vaciar todo el carrito (útil después de checkout)
  /// EXPLICAR: Elimina todos los items de una vez
  Future<void> clearCart() async {
    try {
      await _apiService.delete(ApiConfig.cartEndpoint);
    } catch (e) {
      rethrow;
    }
  }

  /// SYNC CART - POST /api/cart/sync
  /// Sincronizar carrito local con el servidor
  /// EXPLICAR: Útil cuando el usuario tiene items locales y hace login
  /// Combina el carrito local con el del servidor
  Future<Map<String, dynamic>> syncCart(
    List<Map<String, dynamic>> localItems,
  ) async {
    try {
      final data = {'items': localItems};

      final response = await _apiService.post(
        '${ApiConfig.cartEndpoint}/sync',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al sincronizar carrito');
      }
    } catch (e) {
      rethrow;
    }
  }
}
