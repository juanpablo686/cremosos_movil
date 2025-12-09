// services/purchases_service.dart - Servicio de gestión de compras

import '../models/purchase.dart';
import 'api_service.dart';

class PurchasesService {
  final ApiService _apiService;

  PurchasesService(this._apiService);

  /// Obtener lista de compras
  Future<List<Purchase>> getPurchases({
    String? supplierId,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (supplierId != null) queryParams['supplierId'] = supplierId;
      if (status != null) queryParams['status'] = status;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get(
        '/purchases',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((json) => Purchase.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener compras');
    } catch (e) {
      print('Error en getPurchases: $e');
      rethrow;
    }
  }

  /// Obtener detalle de una compra
  Future<Purchase> getPurchaseById(String purchaseId) async {
    try {
      final response = await _apiService.get('/purchases/$purchaseId');

      if (response.data['success'] == true) {
        return Purchase.fromJson(response.data['data']);
      }

      throw Exception('Error al obtener compra');
    } catch (e) {
      print('Error en getPurchaseById: $e');
      rethrow;
    }
  }

  /// Crear nueva compra
  Future<Purchase> createPurchase({
    required String supplierId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/purchases',
        data: {
          'supplierId': supplierId,
          'items': items,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.data['success'] == true) {
        return Purchase.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al crear compra');
    } catch (e) {
      print('Error en createPurchase: $e');
      rethrow;
    }
  }

  /// Actualizar compra
  Future<Purchase> updatePurchase({
    required String purchaseId,
    String? status,
    String? notes,
    String? receivedAt,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (status != null) data['status'] = status;
      if (notes != null) data['notes'] = notes;
      if (receivedAt != null) data['receivedAt'] = receivedAt;

      final response = await _apiService.put('/purchases/$purchaseId', data: data);

      if (response.data['success'] == true) {
        return Purchase.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al actualizar compra');
    } catch (e) {
      print('Error en updatePurchase: $e');
      rethrow;
    }
  }

  /// Eliminar compra
  Future<void> deletePurchase(String purchaseId) async {
    try {
      final response = await _apiService.delete('/purchases/$purchaseId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error al eliminar compra');
      }
    } catch (e) {
      print('Error en deletePurchase: $e');
      rethrow;
    }
  }
}
