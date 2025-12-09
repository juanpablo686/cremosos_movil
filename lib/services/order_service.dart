import '../config/api_config.dart';
import 'api_service.dart';

/// Servicio de Órdenes/Pedidos
/// EXPLICAR EN EXPOSICIÓN: Maneja la creación de pedidos y
/// el historial de compras del usuario

class OrderService {
  final ApiService _apiService;

  OrderService(this._apiService);

  /// CREATE ORDER - POST /api/orders
  /// Crear una nueva orden/pedido a partir del carrito
  /// EXPLICAR: Proceso de checkout completo
  ///
  /// Request body: {
  ///   "shippingAddress": {
  ///     "street": "Calle 123 #45-67",
  ///     "city": "Bogotá",
  ///     "state": "Cundinamarca",
  ///     "postalCode": "110111"
  ///   },
  ///   "paymentMethod": "credit_card",
  ///   "paymentDetails": {
  ///     "cardLast4": "1234",
  ///     "cardBrand": "Visa"
  ///   },
  ///   "notes": "Dejar en portería"
  /// }
  ///
  /// Response: {
  ///   "orderId": "ORD-12345",
  ///   "status": "pending",
  ///   "total": 47600,
  ///   "estimatedDelivery": "2025-12-04T15:00:00Z",
  ///   "order": {...}  // Orden completa
  /// }
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    Map<String, dynamic>? paymentDetails,
    String? notes,
  }) async {
    try {
      final data = {
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        if (paymentDetails != null) 'paymentDetails': paymentDetails,
        if (notes != null) 'notes': notes,
      };

      // POST crea la orden en el servidor
      // EXPLICAR: El servidor toma los items del carrito actual del usuario
      final response = await _apiService.post(
        ApiConfig.ordersEndpoint,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al crear orden');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET ORDER HISTORY - GET /api/orders
  /// Obtener historial de órdenes del usuario autenticado
  /// EXPLICAR: Muestra todas las órdenes previas con su estado
  ///
  /// Query parameters opcionales:
  /// - status: Filtrar por estado (pending, completed, cancelled)
  /// - startDate: Fecha de inicio para filtro
  /// - endDate: Fecha de fin para filtro
  /// - customerId: ID del cliente (solo admin/employee)
  /// - search: Búsqueda por número de orden
  /// - page: Número de página
  /// - limit: Cantidad de órdenes por página
  ///
  /// Response: {
  ///   "orders": [
  ///     {
  ///       "id": "ORD-12345",
  ///       "date": "2025-12-03T10:30:00Z",
  ///       "status": "completed",
  ///       "total": 47600,
  ///       "items": [...],
  ///       ...
  ///     }
  ///   ],
  ///   "meta": {
  ///     "total": 15,
  ///     "page": 1,
  ///     "totalPages": 2
  ///   }
  /// }
  Future<Map<String, dynamic>> getOrderHistory({
    String? status,
    String? startDate,
    String? endDate,
    String? customerId,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (status != null) queryParams['status'] = status;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (customerId != null) queryParams['customerId'] = customerId;
      if (search != null) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiService.get(
        ApiConfig.orderHistoryEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener historial de órdenes');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET ORDER BY ID - GET /api/orders/{orderId}
  /// Obtener detalle completo de una orden específica
  /// EXPLICAR: Muestra información detallada de una orden
  ///
  /// Response: {
  ///   "id": "ORD-12345",
  ///   "userId": 123,
  ///   "status": "completed",
  ///   "items": [...],
  ///   "shippingAddress": {...},
  ///   "paymentMethod": "credit_card",
  ///   "subtotal": 40000,
  ///   "tax": 7600,
  ///   "total": 47600,
  ///   "createdAt": "2025-12-03T10:30:00Z",
  ///   "deliveredAt": "2025-12-03T12:15:00Z"
  /// }
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.ordersEndpoint}/$orderId',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Orden no encontrada');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// CANCEL ORDER - PUT /api/orders/{orderId}/cancel
  /// Cancelar una orden pendiente
  /// EXPLICAR: Solo se pueden cancelar órdenes en estado 'pending'
  ///
  /// Response: {
  ///   "message": "Orden cancelada exitosamente",
  ///   "order": {...}
  /// }
  Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.ordersEndpoint}/$orderId/cancel',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al cancelar orden');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// TRACK ORDER - GET /api/orders/{orderId}/track
  /// Rastrear el estado actual de una orden
  /// EXPLICAR: Muestra el estado de envío en tiempo real
  ///
  /// Response: {
  ///   "orderId": "ORD-12345",
  ///   "status": "in_transit",
  ///   "trackingNumber": "TRK-98765",
  ///   "estimatedDelivery": "2025-12-04T15:00:00Z",
  ///   "history": [
  ///     {
  ///       "status": "pending",
  ///       "date": "2025-12-03T10:30:00Z",
  ///       "description": "Orden recibida"
  ///     },
  ///     {
  ///       "status": "processing",
  ///       "date": "2025-12-03T11:00:00Z",
  ///       "description": "Orden en preparación"
  ///     }
  ///   ]
  /// }
  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.ordersEndpoint}/$orderId/track',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al rastrear orden');
      }
    } catch (e) {
      rethrow;
    }
  }
}
