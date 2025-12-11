// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para gráficos
import '../widgets/app_drawer.dart';
import '../services/api_service.dart';

// Pantalla de Reportes y Estadísticas
// EXPLICAR: Muestra dashboards con gráficos de ventas y estadísticas del negocio
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  Map<String, dynamic>?
  dashboardData; // Datos del dashboard (totales, promedios)
  List<dynamic> recentSales = []; // Ventas recientes para mostrar
  bool isLoading = true; // Estado de carga
  String? errorMessage; // Mensaje de error si falla la carga

  @override
  void initState() {
    super.initState();
    _loadReports(); // Cargar reportes al abrir la pantalla
  }

  // Cargar datos de reportes desde la API
  // EXPLICAR: Obtiene estadísticas del endpoint /reports/dashboard
  Future<void> _loadReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = ApiService();

      // Obtener datos del dashboard (totales de ventas, pedidos, productos)
      final dashboardResponse = await apiService.get('/reports/dashboard');

      setState(() {
        dashboardData = dashboardResponse.data['data'];
        recentSales = dashboardResponse.data['data']['recentOrders'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar reportes: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Reportes y Estadísticas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadReports),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReports,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Ventas Totales',
                          value:
                              '\$${dashboardData?['totalSales']?.toStringAsFixed(0) ?? '0'} COP',
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Total Pedidos',
                          value: '${dashboardData?['totalOrders'] ?? 0}',
                          icon: Icons.shopping_bag,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Clientes Activos',
                          value: '${dashboardData?['activeCustomers'] ?? 0}',
                          icon: Icons.people,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ventas por Categoría',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildCategoryChart(),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ventas de la Semana',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildWeeklySalesChart(),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ventas Recientes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (recentSales.isNotEmpty)
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _buildRecentSalesChart(),
                    ),
                  const SizedBox(height: 16),
                  ...recentSales.map(
                    (sale) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.shopping_bag, color: Colors.white),
                        ),
                        title: Text('Pedido #${sale['orderNumber']}'),
                        subtitle: Text(
                          'Estado: ${_getStatusText(sale['status'])}',
                        ),
                        trailing: Text(
                          '\$${sale['total']?.toStringAsFixed(0) ?? '0'} COP',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryChart() {
    final categories = dashboardData?['salesByCategory'] as List? ?? [];

    if (categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay datos de ventas por categoría',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final colors = [
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];

    // Calcular total de ventas para los porcentajes
    final totalSales = categories.fold<double>(
      0,
      (sum, cat) => sum + ((cat['sales'] as num?)?.toDouble() ?? 0),
    );

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final cat = entry.value;
                final sales = (cat['sales'] as num?)?.toDouble() ?? 0;
                final percentage = totalSales > 0
                    ? (sales / totalSales * 100)
                    : 0;

                return PieChartSectionData(
                  value: sales,
                  title: '${percentage.toStringAsFixed(1)}%',
                  color: colors[index % colors.length],
                  radius: 110,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final cat = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _getCategoryName(cat['category']),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getCategoryName(String category) {
    final names = {
      'arroz_con_leche': 'Arroz',
      'fresas_con_crema': 'Fresas',
      'postres_especiales': 'Postres Esp.',
      'bebidas_cremosas': 'Bebidas Crem.',
      'toppings': 'Toppings',
      'bebidas': 'Bebidas',
      'postres': 'Postres',
    };
    return names[category] ?? category;
  }

  Widget _buildWeeklySalesChart() {
    final dailySales = dashboardData?['dailySales'] as List? ?? [];

    if (dailySales.isEmpty) {
      return const Center(child: Text('No hay datos de ventas semanales'));
    }

    final maxSales = dailySales.fold<double>(
      0,
      (max, day) => (day['sales'] as num).toDouble() > max
          ? (day['sales'] as num).toDouble()
          : max,
    );

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxSales > 0 ? maxSales * 1.2 : 100000,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= dailySales.length) return const Text('');
                final date = dailySales[value.toInt()]['date'] as String;
                final day = DateTime.parse(date).day;
                return Text('$day');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('0');
                return Text('\$${(value / 1000).toStringAsFixed(0)}k');
              },
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: dailySales.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final sales = (day['sales'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(toY: sales, color: Colors.purple, width: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentSalesChart() {
    if (recentSales.isEmpty) {
      return const Center(child: Text('No hay ventas recientes'));
    }

    final maxTotal = recentSales.fold<double>(
      0,
      (max, sale) => (sale['total'] as num).toDouble() > max
          ? (sale['total'] as num).toDouble()
          : max,
    );

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxTotal > 0 ? maxTotal * 1.2 : 100000,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= recentSales.length) return const Text('');
                return Text('#${recentSales[value.toInt()]['orderNumber']}');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('0');
                return Text('\$${(value / 1000).toStringAsFixed(0)}k');
              },
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: recentSales.asMap().entries.map((entry) {
          final index = entry.key;
          final sale = entry.value;
          final total = (sale['total'] as num).toDouble();

          // Colores según el estado del pedido
          Color barColor = Colors.green;
          if (sale['status'] == 'pending') {
            barColor = Colors.orange;
          } else if (sale['status'] == 'processing') {
            barColor = Colors.blue;
          } else if (sale['status'] == 'shipped') {
            barColor = Colors.purple;
          } else if (sale['status'] == 'cancelled') {
            barColor = Colors.red;
          }

          return BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(toY: total, color: barColor, width: 20)],
          );
        }).toList(),
      ),
    );
  }

  String _getStatusText(String status) {
    final statusMap = {
      'pending': 'Pendiente',
      'processing': 'Procesando',
      'shipped': 'Enviado',
      'delivered': 'Entregado',
      'cancelled': 'Cancelado',
    };
    return statusMap[status] ?? status;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
