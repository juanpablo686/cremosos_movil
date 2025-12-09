// services/sales_service.dart - Servicio de gestión de ventas (POS)

import '../models/sale.dart';
import 'api_service.dart';

class SalesService {
  final ApiService _apiService;

  SalesService(this._apiService);

  /// Obtener lista de ventas
  Future<List<Sale>> getSales({
    String? employeeId,
    String? startDate,
    String? endDate,
    String? paymentMethod,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (employeeId != null) queryParams['employeeId'] = employeeId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (paymentMethod != null) queryParams['paymentMethod'] = paymentMethod;

      final response = await _apiService.get(
        '/sales',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((json) => Sale.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener ventas');
    } catch (e) {
      print('Error en getSales: $e');
      rethrow;
    }
  }

  /// Obtener detalle de una venta
  Future<Sale> getSaleById(String saleId) async {
    try {
      final response = await _apiService.get('/sales/$saleId');

      if (response.data['success'] == true) {
        return Sale.fromJson(response.data['data']);
      }

      throw Exception('Error al obtener venta');
    } catch (e) {
      print('Error en getSaleById: $e');
      rethrow;
    }
  }

  /// Crear nueva venta (Punto de Venta)
  Future<Sale> createSale({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    double? discount,
    String? customerName,
    String? customerPhone,
  }) async {
    try {
      final response = await _apiService.post(
        '/sales',
        data: {
          'items': items,
          'paymentMethod': paymentMethod,
          if (discount != null) 'discount': discount,
          if (customerName != null) 'customerName': customerName,
          if (customerPhone != null) 'customerPhone': customerPhone,
        },
      );

      if (response.data['success'] == true) {
        return Sale.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al crear venta');
    } catch (e) {
      print('Error en createSale: $e');
      rethrow;
    }
  }

  /// Obtener resumen de ventas del día
  Future<Map<String, dynamic>> getTodaySummary() async {
    try {
      final response = await _apiService.get('/sales/summary/today');

      if (response.data['success'] == true) {
        return response.data['data'];
      }

      throw Exception('Error al obtener resumen del día');
    } catch (e) {
      print('Error en getTodaySummary: $e');
      rethrow;
    }
  }

  /// Generar ticket de venta
  Future<Map<String, dynamic>> printSaleTicket(String saleId) async {
    try {
      final response = await _apiService.post('/sales/$saleId/print');

      if (response.data['success'] == true) {
        return response.data['data'];
      }

      throw Exception('Error al generar ticket');
    } catch (e) {
      print('Error en printSaleTicket: $e');
      rethrow;
    }
  }
}
