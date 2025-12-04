// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDataApi _$DashboardDataApiFromJson(Map<String, dynamic> json) =>
    DashboardDataApi(
      totalSales: (json['totalSales'] as num).toDouble(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      activeCustomers: (json['activeCustomers'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      comparison: PeriodComparisonApi.fromJson(
        json['comparison'] as Map<String, dynamic>,
      ),
      dailySales: (json['dailySales'] as List<dynamic>)
          .map((e) => DailySalesApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      topProducts: (json['topProducts'] as List<dynamic>)
          .map((e) => TopProductApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesByCategory: (json['salesByCategory'] as List<dynamic>)
          .map((e) => CategorySalesApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentOrders: (json['recentOrders'] as List<dynamic>)
          .map((e) => RecentOrderApi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataApiToJson(
  DashboardDataApi instance,
) => <String, dynamic>{
  'totalSales': instance.totalSales,
  'totalOrders': instance.totalOrders,
  'activeCustomers': instance.activeCustomers,
  'averageOrderValue': instance.averageOrderValue,
  'comparison': instance.comparison.toJson(),
  'dailySales': instance.dailySales.map((e) => e.toJson()).toList(),
  'topProducts': instance.topProducts.map((e) => e.toJson()).toList(),
  'salesByCategory': instance.salesByCategory.map((e) => e.toJson()).toList(),
  'recentOrders': instance.recentOrders.map((e) => e.toJson()).toList(),
};

PeriodComparisonApi _$PeriodComparisonApiFromJson(Map<String, dynamic> json) =>
    PeriodComparisonApi(
      salesChange: (json['salesChange'] as num).toDouble(),
      ordersChange: (json['ordersChange'] as num).toDouble(),
      customersChange: (json['customersChange'] as num).toDouble(),
      aovChange: (json['aovChange'] as num).toDouble(),
    );

Map<String, dynamic> _$PeriodComparisonApiToJson(
  PeriodComparisonApi instance,
) => <String, dynamic>{
  'salesChange': instance.salesChange,
  'ordersChange': instance.ordersChange,
  'customersChange': instance.customersChange,
  'aovChange': instance.aovChange,
};

DailySalesApi _$DailySalesApiFromJson(Map<String, dynamic> json) =>
    DailySalesApi(
      date: DailySalesApi._dateFromJson(json['date'] as String),
      sales: (json['sales'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
    );

Map<String, dynamic> _$DailySalesApiToJson(DailySalesApi instance) =>
    <String, dynamic>{
      'date': DailySalesApi._dateToJson(instance.date),
      'sales': instance.sales,
      'orders': instance.orders,
    };

TopProductApi _$TopProductApiFromJson(Map<String, dynamic> json) =>
    TopProductApi(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      imageUrl: json['imageUrl'] as String,
      unitsSold: (json['unitsSold'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$TopProductApiToJson(TopProductApi instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'imageUrl': instance.imageUrl,
      'unitsSold': instance.unitsSold,
      'revenue': instance.revenue,
    };

CategorySalesApi _$CategorySalesApiFromJson(Map<String, dynamic> json) =>
    CategorySalesApi(
      category: json['category'] as String,
      sales: (json['sales'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$CategorySalesApiToJson(CategorySalesApi instance) =>
    <String, dynamic>{
      'category': instance.category,
      'sales': instance.sales,
      'orders': instance.orders,
      'percentage': instance.percentage,
    };

RecentOrderApi _$RecentOrderApiFromJson(Map<String, dynamic> json) =>
    RecentOrderApi(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String,
      customerName: json['customerName'] as String,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: RecentOrderApi._dateTimeFromJson(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecentOrderApiToJson(RecentOrderApi instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'customerName': instance.customerName,
      'total': instance.total,
      'status': instance.status,
      'createdAt': RecentOrderApi._dateTimeToJson(instance.createdAt),
    };

SalesReportApi _$SalesReportApiFromJson(Map<String, dynamic> json) =>
    SalesReportApi(
      period: json['period'] as String,
      startDate: SalesReportApi._dateFromJson(json['startDate'] as String),
      endDate: SalesReportApi._dateFromJson(json['endDate'] as String),
      totals: SalesTotalsApi.fromJson(json['totals'] as Map<String, dynamic>),
      breakdown: (json['breakdown'] as List<dynamic>)
          .map((e) => SalesPeriodApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      trends: SalesTrendsApi.fromJson(json['trends'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalesReportApiToJson(SalesReportApi instance) =>
    <String, dynamic>{
      'period': instance.period,
      'startDate': SalesReportApi._dateToJson(instance.startDate),
      'endDate': SalesReportApi._dateToJson(instance.endDate),
      'totals': instance.totals.toJson(),
      'breakdown': instance.breakdown.map((e) => e.toJson()).toList(),
      'trends': instance.trends.toJson(),
    };

SalesTotalsApi _$SalesTotalsApiFromJson(Map<String, dynamic> json) =>
    SalesTotalsApi(
      revenue: (json['revenue'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
      customers: (json['customers'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
    );

Map<String, dynamic> _$SalesTotalsApiToJson(SalesTotalsApi instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'orders': instance.orders,
      'customers': instance.customers,
      'averageOrderValue': instance.averageOrderValue,
      'tax': instance.tax,
      'shipping': instance.shipping,
    };

SalesPeriodApi _$SalesPeriodApiFromJson(Map<String, dynamic> json) =>
    SalesPeriodApi(
      label: json['label'] as String,
      startDate: SalesPeriodApi._dateFromJson(json['startDate'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
    );

Map<String, dynamic> _$SalesPeriodApiToJson(SalesPeriodApi instance) =>
    <String, dynamic>{
      'label': instance.label,
      'startDate': SalesPeriodApi._dateToJson(instance.startDate),
      'revenue': instance.revenue,
      'orders': instance.orders,
    };

SalesTrendsApi _$SalesTrendsApiFromJson(Map<String, dynamic> json) =>
    SalesTrendsApi(
      direction: json['direction'] as String,
      growthRate: (json['growthRate'] as num).toDouble(),
      projectedSales: (json['projectedSales'] as num).toDouble(),
    );

Map<String, dynamic> _$SalesTrendsApiToJson(SalesTrendsApi instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'growthRate': instance.growthRate,
      'projectedSales': instance.projectedSales,
    };

ProductPerformanceApi _$ProductPerformanceApiFromJson(
  Map<String, dynamic> json,
) => ProductPerformanceApi(
  products: (json['products'] as List<dynamic>)
      .map((e) => ProductStatsApi.fromJson(e as Map<String, dynamic>))
      .toList(),
  categoryPerformance: ProductCategoryPerformanceApi.fromJson(
    json['categoryPerformance'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ProductPerformanceApiToJson(
  ProductPerformanceApi instance,
) => <String, dynamic>{
  'products': instance.products.map((e) => e.toJson()).toList(),
  'categoryPerformance': instance.categoryPerformance.toJson(),
};

ProductStatsApi _$ProductStatsApiFromJson(Map<String, dynamic> json) =>
    ProductStatsApi(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      unitsSold: (json['unitsSold'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewsCount: (json['reviewsCount'] as num).toInt(),
      currentStock: (json['currentStock'] as num).toInt(),
      profitMargin: (json['profitMargin'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductStatsApiToJson(ProductStatsApi instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'category': instance.category,
      'unitsSold': instance.unitsSold,
      'revenue': instance.revenue,
      'averageRating': instance.averageRating,
      'reviewsCount': instance.reviewsCount,
      'currentStock': instance.currentStock,
      'profitMargin': instance.profitMargin,
    };

ProductCategoryPerformanceApi _$ProductCategoryPerformanceApiFromJson(
  Map<String, dynamic> json,
) => ProductCategoryPerformanceApi(
  bestPerforming: json['bestPerforming'] as String,
  worstPerforming: json['worstPerforming'] as String,
  categoryRevenue: (json['categoryRevenue'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
);

Map<String, dynamic> _$ProductCategoryPerformanceApiToJson(
  ProductCategoryPerformanceApi instance,
) => <String, dynamic>{
  'bestPerforming': instance.bestPerforming,
  'worstPerforming': instance.worstPerforming,
  'categoryRevenue': instance.categoryRevenue,
};

CustomerStatsApi _$CustomerStatsApiFromJson(Map<String, dynamic> json) =>
    CustomerStatsApi(
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      newCustomers: (json['newCustomers'] as num).toInt(),
      returningCustomers: (json['returningCustomers'] as num).toInt(),
      retentionRate: (json['retentionRate'] as num).toDouble(),
      topCustomers: (json['topCustomers'] as List<dynamic>)
          .map((e) => TopCustomerApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      demographics: CustomerDemographicsApi.fromJson(
        json['demographics'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CustomerStatsApiToJson(CustomerStatsApi instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'newCustomers': instance.newCustomers,
      'returningCustomers': instance.returningCustomers,
      'retentionRate': instance.retentionRate,
      'topCustomers': instance.topCustomers.map((e) => e.toJson()).toList(),
      'demographics': instance.demographics.toJson(),
    };

TopCustomerApi _$TopCustomerApiFromJson(Map<String, dynamic> json) =>
    TopCustomerApi(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
    );

Map<String, dynamic> _$TopCustomerApiToJson(TopCustomerApi instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'totalOrders': instance.totalOrders,
      'totalSpent': instance.totalSpent,
      'averageOrderValue': instance.averageOrderValue,
    };

CustomerDemographicsApi _$CustomerDemographicsApiFromJson(
  Map<String, dynamic> json,
) => CustomerDemographicsApi(
  byCity: Map<String, int>.from(json['byCity'] as Map),
  byAgeGroup: Map<String, int>.from(json['byAgeGroup'] as Map),
  maleCount: (json['maleCount'] as num).toInt(),
  femaleCount: (json['femaleCount'] as num).toInt(),
  otherCount: (json['otherCount'] as num).toInt(),
);

Map<String, dynamic> _$CustomerDemographicsApiToJson(
  CustomerDemographicsApi instance,
) => <String, dynamic>{
  'byCity': instance.byCity,
  'byAgeGroup': instance.byAgeGroup,
  'maleCount': instance.maleCount,
  'femaleCount': instance.femaleCount,
  'otherCount': instance.otherCount,
};
