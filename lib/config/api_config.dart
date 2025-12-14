/// Configuración de la API REST
/// Este archivo centraliza toda la configuración relacionada con la API
/// IMPORTANTE PARA EXPOSICIÓN: Explicar que esto permite cambiar fácilmente entre
/// ambientes (desarrollo, producción) sin modificar todo el código

class ApiConfig {
  // URL base de la API - En producción cambiaría a la URL del servidor
  // Para desarrollo local usamos localhost o la IP de tu máquina
  static const String baseUrl = 'http://localhost:3000/api';

  // Timeout para las peticiones HTTP (10 segundos - optimizado)
  // EXPLICAR: Si la petición tarda más de 10s, se cancela automáticamente
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints de Autenticación (3 endpoints requeridos)
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/users/profile';
  static const String updateProfileEndpoint = '/users/profile';

  // Endpoints de Productos (3 endpoints requeridos)
  static const String productsEndpoint = '/products';
  static const String productDetailEndpoint = '/products'; // + /{id}
  static const String featuredProductsEndpoint = '/products/featured';

  // Endpoints de Carrito (4 endpoints - operaciones CRUD)
  static const String cartEndpoint = '/cart';
  static const String cartItemsEndpoint = '/cart/items';

  // Endpoints de Órdenes (2 endpoints requeridos)
  static const String ordersEndpoint = '/orders';
  static const String orderHistoryEndpoint = '/orders';

  // Endpoints de Reportes (2 endpoints requeridos)
  static const String dashboardEndpoint = '/reports/dashboard';
  static const String salesReportEndpoint = '/reports/sales';

  // Headers comunes para todas las peticiones
  // EXPLICAR: Content-Type indica que enviamos/recibimos JSON
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Header de autorización con token JWT
  // EXPLICAR EN EXPOSICIÓN: Bearer Token es un estándar de seguridad
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
