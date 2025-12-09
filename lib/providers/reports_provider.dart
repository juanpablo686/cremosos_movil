// providers/reports_provider.dart - Provider de Reportes

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reports.dart';
import '../services/report_service.dart';
import '../data/reports_data.dart';
import 'auth_provider.dart';

// Estado de reportes
class ReportsState {
  final SalesReport? salesReport;
  final List<Banner> banners;
  final bool isLoading;
  final String? error;

  ReportsState({
    this.salesReport,
    this.banners = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    SalesReport? salesReport,
    List<Banner>? banners,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      salesReport: salesReport ?? this.salesReport,
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notificador de reportes
class ReportsNotifier extends StateNotifier<ReportsState> {
  final Ref ref;

  ReportsNotifier(this.ref) : super(ReportsState()) {
    loadReports();
  }

  // Cargar reportes
  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final apiService = ref.read(apiServiceProvider);
      final reportService = ReportService(apiService);

      // Obtener datos del dashboard desde el backend
      final dashboardData = await reportService.getDashboardData(
        period: 'month',
      );

      // Convertir a SalesReport
      final report = SalesReport(
        totalSales: (dashboardData['totalRevenue'] ?? 0).toInt(),
        totalOrders: dashboardData['totalOrders'] ?? 0,
        averageTicket: (dashboardData['averageOrderValue'] ?? 0).toInt(),
        totalCustomers: dashboardData['totalCustomers'] ?? 0,
        newCustomers: dashboardData['newCustomers'] ?? 0,
        returningCustomers: dashboardData['returningCustomers'] ?? 0,
        topProducts: [],
        categorySales: [],
        dailySales: [],
        period: 'month',
        periodStart: DateTime.now().subtract(const Duration(days: 30)),
        periodEnd: DateTime.now(),
        comparisonPeriod: 'previous_month',
        growthRate: (dashboardData['growthRate'] ?? 0).toDouble(),
        topSellingCategory: dashboardData['topSellingCategory'] ?? '',
        lowStockProducts: [],
      );

      state = ReportsState(salesReport: report, banners: [], isLoading: false);
    } catch (e) {
      print('Error cargando reportes desde backend: $e');
      print('Usando datos mock como fallback...');
      // Si falla el backend, usar datos mock
      final report = getSalesReport();
      final banners = getActiveBanners();

      state = ReportsState(
        salesReport: report,
        banners: banners,
        isLoading: false,
      );
    }
  }

  // Refrescar reportes
  Future<void> refresh() async {
    await loadReports();
  }
}

// Provider de reportes
final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((
  ref,
) {
  return ReportsNotifier(ref);
});

// Provider de banners activos
final activeBannersProvider = Provider<List<Banner>>((ref) {
  return ref.watch(reportsProvider).banners;
});

// Provider de reporte de ventas
final salesReportProvider = Provider<SalesReport?>((ref) {
  return ref.watch(reportsProvider).salesReport;
});

// Provider de top productos
final topProductsProvider = Provider<List<TopProduct>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.topProducts ?? [];
});

// Provider de ventas por categoría
final categorySalesProvider = Provider<List<CategorySales>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.categorySales ?? [];
});

// Provider de ventas diarias
final dailySalesProvider = Provider<List<DailySales>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.dailySales ?? [];
});

// Provider de estadísticas de inventario (temporal - devuelve datos vacíos)
final inventoryStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return {'totalProducts': 0, 'lowStock': 0, 'outOfStock': 0};
});

// Provider de estadísticas de clientes (temporal - devuelve datos vacíos)
final customerStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return {'totalCustomers': 0, 'newThisMonth': 0, 'activeCustomers': 0};
});
