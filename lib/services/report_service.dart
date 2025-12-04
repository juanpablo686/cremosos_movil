import '../config/api_config.dart';
import 'api_service.dart';

/// Servicio de Reportes y Estadísticas
/// EXPLICAR EN EXPOSICIÓN: Obtiene datos estadísticos del servidor
/// para mostrar en dashboards y gráficos

class ReportService {
  final ApiService _apiService;

  ReportService(this._apiService);

  /// GET DASHBOARD DATA - GET /api/reports/dashboard
  /// Obtener datos estadísticos para el dashboard principal
  /// EXPLICAR: Endpoint que retorna múltiples métricas en una sola petición
  ///
  /// Query parameters:
  /// - period: Período de tiempo (day, week, month, year)
  /// - startDate: Fecha de inicio (ISO 8601)
  /// - endDate: Fecha de fin (ISO 8601)
  ///
  /// Response: {
  ///   "totalRevenue": 15000000,
  ///   "totalOrders": 234,
  ///   "averageOrderValue": 64102,
  ///   "newCustomers": 45,
  ///   "topProducts": [
  ///     {
  ///       "productId": "acl-001",
  ///       "name": "Arroz con Leche Tradicional",
  ///       "sales": 89,
  ///       "revenue": 1602000
  ///     }
  ///   ],
  ///   "categoryPerformance": {
  ///     "arrozConLeche": 35.5,
  ///     "fresasConCrema": 25.2,
  ///     ...
  ///   },
  ///   "recentOrders": [...]
  /// }
  Future<Map<String, dynamic>> getDashboardData({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (period != null) queryParams['period'] = period;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get(
        ApiConfig.dashboardEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener datos del dashboard');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET SALES REPORT - GET /api/reports/sales
  /// Obtener reporte detallado de ventas
  /// EXPLICAR: Datos específicos para gráficos de ventas
  /// Generalmente solo accesible para usuarios con rol admin
  ///
  /// Query parameters:
  /// - period: day, week, month, year
  /// - groupBy: Agrupar por (day, week, month, category, product)
  /// - startDate: Fecha inicio
  /// - endDate: Fecha fin
  ///
  /// Response: {
  ///   "period": "month",
  ///   "totalSales": 15000000,
  ///   "salesData": [
  ///     {
  ///       "date": "2025-01",
  ///       "sales": 1200000,
  ///       "orders": 45,
  ///       "customers": 38
  ///     },
  ///     {
  ///       "date": "2025-02",
  ///       "sales": 1350000,
  ///       "orders": 52,
  ///       "customers": 42
  ///     }
  ///   ],
  ///   "growth": {
  ///     "percentage": 12.5,
  ///     "trend": "up"
  ///   }
  /// }
  Future<Map<String, dynamic>> getSalesReport({
    String? period,
    String? groupBy,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (period != null) queryParams['period'] = period;
      if (groupBy != null) queryParams['groupBy'] = groupBy;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get(
        ApiConfig.salesReportEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener reporte de ventas');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET PRODUCT PERFORMANCE - GET /api/reports/products
  /// Obtener rendimiento de productos
  /// EXPLICAR: Análisis de qué productos se venden más/menos
  ///
  /// Response: {
  ///   "topProducts": [...],
  ///   "lowStockProducts": [...],
  ///   "bestRatedProducts": [...],
  ///   "categoryBreakdown": {...}
  /// }
  Future<Map<String, dynamic>> getProductPerformance() async {
    try {
      final response = await _apiService.get('/reports/products');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener rendimiento de productos');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET CUSTOMER STATS - GET /api/reports/customers
  /// Obtener estadísticas de clientes
  /// EXPLICAR: Datos sobre comportamiento de usuarios
  ///
  /// Response: {
  ///   "totalCustomers": 1250,
  ///   "newCustomers": 45,
  ///   "activeCustomers": 320,
  ///   "customerRetention": 78.5,
  ///   "averageOrdersPerCustomer": 3.2
  /// }
  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await _apiService.get('/reports/customers');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener estadísticas de clientes');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// EXPORT REPORT - GET /api/reports/export
  /// Exportar reporte en formato específico (CSV, PDF, Excel)
  /// EXPLICAR: Permite descargar reportes para análisis externo
  ///
  /// Query parameters:
  /// - type: sales, products, customers
  /// - format: csv, pdf, xlsx
  /// - period: day, week, month, year
  ///
  /// Response: Archivo binario para descargar
  Future<dynamic> exportReport({
    required String type,
    required String format,
    String? period,
  }) async {
    try {
      final queryParams = {
        'type': type,
        'format': format,
        if (period != null) 'period': period,
      };

      final response = await _apiService.get(
        '/reports/export',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al exportar reporte');
      }
    } catch (e) {
      rethrow;
    }
  }
}
