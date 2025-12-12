// models/reports.dart - Modelos de Reportes

class Banner {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? backgroundColor;
  final String? textColor;
  final String? ctaText;
  final String? ctaLink;
  final bool isActive;
  final int priority;
  final DateTime startDate;
  final DateTime? endDate;

  Banner({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.backgroundColor,
    this.textColor,
    this.ctaText,
    this.ctaLink,
    required this.isActive,
    this.priority = 0,
    required this.startDate,
    this.endDate,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      image: json['image'] as String,
      backgroundColor: json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      ctaText: json['ctaText'] as String?,
      ctaLink: json['ctaLink'] as String?,
      isActive: json['isActive'] as bool,
      priority: json['priority'] as int? ?? 0,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'ctaText': ctaText,
      'ctaLink': ctaLink,
      'isActive': isActive,
      'priority': priority,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

class SalesReport {
  final int totalSales;
  final int totalOrders;
  final int averageTicket;
  final int totalCustomers;
  final int newCustomers;
  final int returningCustomers;
  final List<TopProduct> topProducts;
  final List<CategorySales> categorySales;
  final List<DailySales> dailySales;
  final String period;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String comparisonPeriod;
  final double growthRate;
  final String topSellingCategory;
  final List<String> lowStockProducts;

  SalesReport({
    required this.totalSales,
    required this.totalOrders,
    required this.averageTicket,
    required this.totalCustomers,
    required this.newCustomers,
    required this.returningCustomers,
    required this.topProducts,
    required this.categorySales,
    required this.dailySales,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.comparisonPeriod,
    required this.growthRate,
    required this.topSellingCategory,
    required this.lowStockProducts,
  });
}

class TopProduct {
  final String productId;
  final String productName;
  final String productImage;
  final int sales;
  final int units;
  final double trend;

  TopProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.sales,
    required this.units,
    required this.trend,
  });
}

class CategorySales {
  final String category;
  final int sales;
  final double percentage;
  final int orders;
  final String color;

  CategorySales({
    required this.category,
    required this.sales,
    required this.percentage,
    required this.orders,
    required this.color,
  });
}

class DailySales {
  final DateTime date;
  final int sales;
  final int orders;
  final int averageTicket;

  DailySales({
    required this.date,
    required this.sales,
    required this.orders,
    required this.averageTicket,
  });
}
