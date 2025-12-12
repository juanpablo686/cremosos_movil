/// Modelo de Reportes - Versión con API REST
/// EXPLICAR EN EXPOSICIÓN: Modelos para dashboards y análisis de negocio
/// Permiten visualizar métricas de ventas, productos y clientes

import 'package:json_annotation/json_annotation.dart';

part 'report_api.g.dart';

/// Dashboard Principal
/// EXPLICAR: Resumen ejecutivo con KPIs (Key Performance Indicators)
@JsonSerializable(explicitToJson: true)
class DashboardDataApi {
  /// Ventas totales del período
  final double totalSales;

  /// Número total de órdenes
  final int totalOrders;

  /// Número de clientes activos
  final int activeCustomers;

  /// Ticket promedio (venta promedio por orden)
  final double averageOrderValue;

  /// Comparación con período anterior
  final PeriodComparisonApi comparison;

  /// Ventas por día (para gráfica)
  final List<DailySalesApi> dailySales;

  /// Top 5 productos más vendidos
  final List<TopProductApi> topProducts;

  /// Distribución de ventas por categoría
  final List<CategorySalesApi> salesByCategory;

  /// Órdenes recientes
  final List<RecentOrderApi> recentOrders;

  DashboardDataApi({
    required this.totalSales,
    required this.totalOrders,
    required this.activeCustomers,
    required this.averageOrderValue,
    required this.comparison,
    required this.dailySales,
    required this.topProducts,
    required this.salesByCategory,
    required this.recentOrders,
  });

  factory DashboardDataApi.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataApiFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataApiToJson(this);
}

/// Comparación entre períodos
/// EXPLICAR: Para mostrar tendencias (↑ ↓)
@JsonSerializable()
class PeriodComparisonApi {
  final double salesChange; // Porcentaje de cambio en ventas
  final double ordersChange; // Porcentaje de cambio en órdenes
  final double customersChange; // Porcentaje de cambio en clientes
  final double aovChange; // Cambio en ticket promedio

  PeriodComparisonApi({
    required this.salesChange,
    required this.ordersChange,
    required this.customersChange,
    required this.aovChange,
  });

  factory PeriodComparisonApi.fromJson(Map<String, dynamic> json) =>
      _$PeriodComparisonApiFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodComparisonApiToJson(this);

  /// Ventas mejoraron?
  bool get salesIncreased => salesChange > 0;

  /// Formatea el cambio como porcentaje
  String formatChange(double change) {
    final sign = change > 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(1)}%';
  }
}

/// Ventas Diarias (para gráfica de líneas)
@JsonSerializable()
class DailySalesApi {
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime date;

  final double sales;
  final int orders;

  DailySalesApi({
    required this.date,
    required this.sales,
    required this.orders,
  });

  factory DailySalesApi.fromJson(Map<String, dynamic> json) =>
      _$DailySalesApiFromJson(json);

  Map<String, dynamic> toJson() => _$DailySalesApiToJson(this);

  static DateTime _dateFromJson(String json) => DateTime.parse(json);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}

/// Top Producto
@JsonSerializable()
class TopProductApi {
  final String productId;
  final String productName;
  final String imageUrl;
  final int unitsSold;
  final double revenue;

  TopProductApi({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.unitsSold,
    required this.revenue,
  });

  factory TopProductApi.fromJson(Map<String, dynamic> json) =>
      _$TopProductApiFromJson(json);

  Map<String, dynamic> toJson() => _$TopProductApiToJson(this);

  String get formattedRevenue => '\$${revenue.toStringAsFixed(0)}';
}

/// Ventas por Categoría (para gráfica de pie)
@JsonSerializable()
class CategorySalesApi {
  final String category;
  final double sales;
  final int orders;
  final double percentage; // % del total

  CategorySalesApi({
    required this.category,
    required this.sales,
    required this.orders,
    required this.percentage,
  });

  factory CategorySalesApi.fromJson(Map<String, dynamic> json) =>
      _$CategorySalesApiFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySalesApiToJson(this);
}

/// Orden Reciente (resumen)
@JsonSerializable()
class RecentOrderApi {
  final String orderId;
  final String orderNumber;
  final String customerName;
  final double total;
  final String status;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  RecentOrderApi({
    required this.orderId,
    required this.orderNumber,
    required this.customerName,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory RecentOrderApi.fromJson(Map<String, dynamic> json) =>
      _$RecentOrderApiFromJson(json);

  Map<String, dynamic> toJson() => _$RecentOrderApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}

/// Reporte de Ventas Detallado
/// EXPLICAR: Para análisis más profundo con filtros de fecha
@JsonSerializable(explicitToJson: true)
class SalesReportApi {
  final String period; // 'daily', 'weekly', 'monthly', 'yearly'

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime startDate;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime endDate;

  /// Totales del período
  final SalesTotalsApi totals;

  /// Desglose por período (días, semanas, meses)
  final List<SalesPeriodApi> breakdown;

  /// Tendencias
  final SalesTrendsApi trends;

  SalesReportApi({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.totals,
    required this.breakdown,
    required this.trends,
  });

  factory SalesReportApi.fromJson(Map<String, dynamic> json) =>
      _$SalesReportApiFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReportApiToJson(this);

  static DateTime _dateFromJson(String json) => DateTime.parse(json);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}

@JsonSerializable()
class SalesTotalsApi {
  final double revenue;
  final int orders;
  final int customers;
  final double averageOrderValue;
  final double tax;
  final double shipping;

  SalesTotalsApi({
    required this.revenue,
    required this.orders,
    required this.customers,
    required this.averageOrderValue,
    required this.tax,
    required this.shipping,
  });

  factory SalesTotalsApi.fromJson(Map<String, dynamic> json) =>
      _$SalesTotalsApiFromJson(json);

  Map<String, dynamic> toJson() => _$SalesTotalsApiToJson(this);
}

@JsonSerializable()
class SalesPeriodApi {
  final String label; // "Enero 2024", "Semana 3", etc

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime startDate;

  final double revenue;
  final int orders;

  SalesPeriodApi({
    required this.label,
    required this.startDate,
    required this.revenue,
    required this.orders,
  });

  factory SalesPeriodApi.fromJson(Map<String, dynamic> json) =>
      _$SalesPeriodApiFromJson(json);

  Map<String, dynamic> toJson() => _$SalesPeriodApiToJson(this);

  static DateTime _dateFromJson(String json) => DateTime.parse(json);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}

@JsonSerializable()
class SalesTrendsApi {
  final String direction; // 'up', 'down', 'stable'
  final double growthRate; // Tasa de crecimiento
  final double projectedSales; // Proyección para próximo período

  SalesTrendsApi({
    required this.direction,
    required this.growthRate,
    required this.projectedSales,
  });

  factory SalesTrendsApi.fromJson(Map<String, dynamic> json) =>
      _$SalesTrendsApiFromJson(json);

  Map<String, dynamic> toJson() => _$SalesTrendsApiToJson(this);

  bool get isGrowing => direction == 'up';
}

/// Reporte de Rendimiento de Productos
@JsonSerializable(explicitToJson: true)
class ProductPerformanceApi {
  final List<ProductStatsApi> products;
  final ProductCategoryPerformanceApi categoryPerformance;

  ProductPerformanceApi({
    required this.products,
    required this.categoryPerformance,
  });

  factory ProductPerformanceApi.fromJson(Map<String, dynamic> json) =>
      _$ProductPerformanceApiFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPerformanceApiToJson(this);
}

@JsonSerializable()
class ProductStatsApi {
  final String productId;
  final String productName;
  final String category;
  final int unitsSold;
  final double revenue;
  final double averageRating;
  final int reviewsCount;
  final int currentStock;
  final double profitMargin;

  ProductStatsApi({
    required this.productId,
    required this.productName,
    required this.category,
    required this.unitsSold,
    required this.revenue,
    required this.averageRating,
    required this.reviewsCount,
    required this.currentStock,
    required this.profitMargin,
  });

  factory ProductStatsApi.fromJson(Map<String, dynamic> json) =>
      _$ProductStatsApiFromJson(json);

  Map<String, dynamic> toJson() => _$ProductStatsApiToJson(this);

  /// ¿Necesita reabastecimiento?
  bool get needsRestock => currentStock < 10;

  /// ¿Es un best-seller?
  bool get isBestSeller => unitsSold > 50;
}

@JsonSerializable()
class ProductCategoryPerformanceApi {
  final String bestPerforming;
  final String worstPerforming;
  final Map<String, double> categoryRevenue;

  ProductCategoryPerformanceApi({
    required this.bestPerforming,
    required this.worstPerforming,
    required this.categoryRevenue,
  });

  factory ProductCategoryPerformanceApi.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryPerformanceApiFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryPerformanceApiToJson(this);
}

/// Estadísticas de Clientes
@JsonSerializable(explicitToJson: true)
class CustomerStatsApi {
  final int totalCustomers;
  final int newCustomers;
  final int returningCustomers;
  final double retentionRate;
  final List<TopCustomerApi> topCustomers;
  final CustomerDemographicsApi demographics;

  CustomerStatsApi({
    required this.totalCustomers,
    required this.newCustomers,
    required this.returningCustomers,
    required this.retentionRate,
    required this.topCustomers,
    required this.demographics,
  });

  factory CustomerStatsApi.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatsApiFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerStatsApiToJson(this);
}

@JsonSerializable()
class TopCustomerApi {
  final String customerId;
  final String customerName;
  final int totalOrders;
  final double totalSpent;
  final double averageOrderValue;

  TopCustomerApi({
    required this.customerId,
    required this.customerName,
    required this.totalOrders,
    required this.totalSpent,
    required this.averageOrderValue,
  });

  factory TopCustomerApi.fromJson(Map<String, dynamic> json) =>
      _$TopCustomerApiFromJson(json);

  Map<String, dynamic> toJson() => _$TopCustomerApiToJson(this);
}

@JsonSerializable()
class CustomerDemographicsApi {
  final Map<String, int> byCity;
  final Map<String, int> byAgeGroup;
  final int maleCount;
  final int femaleCount;
  final int otherCount;

  CustomerDemographicsApi({
    required this.byCity,
    required this.byAgeGroup,
    required this.maleCount,
    required this.femaleCount,
    required this.otherCount,
  });

  factory CustomerDemographicsApi.fromJson(Map<String, dynamic> json) =>
      _$CustomerDemographicsApiFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDemographicsApiToJson(this);
}
